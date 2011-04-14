Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab1DNVvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:51:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34761 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1DNVvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:51:35 -0400
MIME-Version: 1.0
In-Reply-To: <20110412060813.GS9690@prithivi.gnumonks.org>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
	<20110409130945.GC3248@prithivi.gnumonks.org>
	<BANLkTinTXNby_zc7yz29hAdRmNK3rRht9A@mail.gmail.com>
	<20110412060813.GS9690@prithivi.gnumonks.org>
Date: Thu, 14 Apr 2011 18:51:33 -0300
Message-ID: <BANLkTi=T-ozrco3HYJmLExxcxy3t3YZgwg@mail.gmail.com>
Subject: Re: [RFC] NFC subsystem prototype
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: Harald Welte <laforge@gnumonks.org>
Cc: linux-kernel@vger.kernel.org,
        Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

2011/4/12 Harald Welte <laforge@gnumonks.org>:
> Hi Lauro,
>
> On Mon, Apr 11, 2011 at 08:31:11PM -0300, Lauro Ramos Venancio wrote:
>
>> 2011/4/9 Harald Welte <laforge@gnumonks.org>:
>>
>> > 0) why not create a general RFID subsystem instead of locking it down to
>> >   NFC?  NFC is sort-of a superset of ISO 14443, so it would make more
>> >   sense to have a generic framework that can support not only Mifare + NFC
>> >   but all types of ISO 14443 (A / B) as well as ISO 15693.  This would mean
>> >   other applications like electronic ID cards and ICAO-compliant passports
>> >   would fit into the picture - even though not being NFC
>>
>> The prototype supports ISO 14443 (A/B), MIFARE, Felica and Jewel. It's
>> straightforward to add ISO 15693 support. So I think it is possible to
>> support these applications using the NFC subsystem.
>
> Then I suggest renaming the system.  I think it is a bit confusing to call
> something NFC if in fact it is a way more generic RFID system for most common
> 13.56MHz based systems.
>
> In other words: NFC depends on ISO 14443, but ISO 14443 does not depend on NFC,
> so it would be a bit unconventional or unintuitive to use a NFC subsystem to
> talk with non-NFC ISO 14443 cards/transponders.
>

The boundary between NFC and RFID is not fully clear. This prototype
was developed based on NFC Forum documents. NFC Forum tags use all
these protocols (Jewel - Tag 1, Mifare - Tag 2, Felica - Tag 3,
ISO14443 - Tag 4).
My concern on renaming the subsystem is to ensure that its interface
is suitable also for the non-NFC Forum tags.


Regards,

Lauro Ramos Venancio
INdT - Instituto Nokia de Tecnologia
