Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759735Ab0FJUMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 16:12:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61402 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0FJUMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 16:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tO90JZxFv+bthHWFoT6vA8SnGwrC9cIwXP7/0vZ972nIcSsLHNB6QUj8+6a6SVE2fK
         nkE2K3foEciT5vRQ52Y5qBXXU/eJAta4/YZiy5Zxi3yO7Z3KA6EXN45E4F1sHvP3m7Te
         HkL+NkOXxQiMGzvoyyMaPbT4Gqwb6BNOYMkgg=
MIME-Version: 1.0
In-Reply-To: <4C11427F.5090007@libero.it>
References: <AANLkTimrZvKyh6zYnUg2xzDVBVr5NxqtJhxZ42AVhkVI@mail.gmail.com>
	<4C112E7B.1040101@nortel.com>
	<AANLkTinIAKHVYKiILxQZXTr30K_Cr5EZQwRzNpYlLULw@mail.gmail.com>
	<4C113BC2.6070000@libero.it>
	<AANLkTikrKsMagIl0bmcDC4j98_MZrExyoduQXEy_ak3H@mail.gmail.com>
	<AANLkTin_r58efRXM609hT_nc-oO_ojPHzsgOU92bEI9s@mail.gmail.com>
	<4C11427F.5090007@libero.it>
Date: Thu, 10 Jun 2010 14:12:13 -0600
Message-ID: <AANLkTikFdpwJGZPXrAHomy6_Plr7A12PzS_XFHG8Clgm@mail.gmail.com>
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

Storage will probably be something really cheap.  So I assume flash.
But, possibly a USB stick type device.   Maybe an IDE based solid
state storage device.


On Thu, Jun 10, 2010 at 1:52 PM, Massimiliano Galanti
<massiblue@libero.it> wrote:
> Well, not quite. See i.e. AXFS, or squashfs that are ro and flash oriented
> by design.
>
> Anyway, if you're stuck with NTFS/VFAT and can't use NOR...
>
> (Just curious of what technology are you relying on for storage)
>
> Il 10/06/2010 21:42, Brian Gordon ha scritto:
>>
>> Sorry, I take it back.   This wont work for me because I wont have
>> NOR.   Also, I only want the "in-place" to apply to read-only pages.
>> This looks like all reads and writes get passed to the underlying
>> storage and I can't suffer flash page erase/writes to update a
>> variable. :)  The device will wear out and meaningful work would be
>> starved.
>
> --
> Massimiliano
>
