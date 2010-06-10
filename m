Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759649Ab0FJTnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 15:43:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40413 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756Ab0FJTm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 15:42:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z8/+pvEXOdbf6HoWgQXFzRVLqSitVxS/ZoNxnZUYOAndxfi/A93EhaT396Bis9CaU4
         upebRxiuYXHH5PHYH6ATGY1AaBawrqo1WNT5H+naubQY4vVdK3ZkXk/prI5c8652m6oJ
         GqbIZRudNziluPi3itxPYWgmn4YLusWNqgwZo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikrKsMagIl0bmcDC4j98_MZrExyoduQXEy_ak3H@mail.gmail.com>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
	<4C112E7B.1040101@nortel.com>
	<AANLkTinIAKHVYKiILxQZXTr30K_Cr5EZQwRzNpYlLULw@mail.gmail.com>
	<4C113BC2.6070000@libero.it>
	<AANLkTikrKsMagIl0bmcDC4j98_MZrExyoduQXEy_ak3H@mail.gmail.com>
Date: Thu, 10 Jun 2010 13:42:55 -0600
Message-ID: <AANLkTin_r58efRXM609hT_nc-oO_ojPHzsgOU92bEI9s@mail.gmail.com>
Subject: Re: Aerospace and linux
From: Brian Gordon <legerde@gmail.com>
To: Massimiliano Galanti <massiblue@libero.it>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I take it back.   This wont work for me because I wont have
NOR.   Also, I only want the "in-place" to apply to read-only pages.
This looks like all reads and writes get passed to the underlying
storage and I can't suffer flash page erase/writes to update a
variable. :)  The device will wear out and meaningful work would be
starved.

On Thu, Jun 10, 2010 at 1:37 PM, Brian Gordon <legerde@gmail.com> wrote:
> Yes.  Thats exactly what I am looking for.   Even if there is a speed
> penalty, I wouldn't mind so much.  However wikipedia says that XIP is
> filesystem dependent and im stuck with FAT32 or NTFS.   Wikipedia
> claims NTFS can do XIP.   Is this true under linux?
>
> On Thu, Jun 10, 2010 at 1:23 PM, Massimiliano Galanti
> <massiblue@libero.it> wrote:
>>
>>> What about .ro and .text sections of an executable?   I would think
>>> kernel support for that would be required.   If its application data,
>>> then all sorts of things are possible like you described.   Ive also
>>> seen critical ram variables be stored in triplicate and then
>>> compared/voted just to ensure no silent SEU corruption.
>>
>> Maybe slightly off topic but... if flash is safer than ram, what about using
>> XIP (where possible, e.g. on NORs)? That would not put .data sections into
>> ram, at least.
>>
>> --
>> Massimiliano
>>
>
