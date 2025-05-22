// Copyright (c) 2011-2020 The Arkham Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef ARKHAM_QT_ARKHAMADDRESSVALIDATOR_H
#define ARKHAM_QT_ARKHAMADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class ArkhamAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit ArkhamAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

/** Arkham address widget validator, checks for a valid arkham address.
 */
class ArkhamAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit ArkhamAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const override;
};

#endif // ARKHAM_QT_ARKHAMADDRESSVALIDATOR_H
