Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0FHOpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:45:00 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54147 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab0FHOo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=oR2cFZJlHHj7AWeG9pn3qx77uSaBE7sE91+nImQ937k0lb62dkrhc7cvTOS3+TYzT+
         byTDJONKHwzrpT5U5Hi7byMEVcsW6s9ee/eGNi1FARdCQrBEbNP1bmnIO2d9ltbvFm8H
         QUuCWV7aQ57qJa9Fc60OdREHEkIeX6F5VZ2/8=
MIME-Version: 1.0
In-Reply-To: <15142.1275975644@localhost>
References: <AANLkTinQatQEYahpkN3bT-S5C41HqRoH--gTrvIbGs_c@mail.gmail.com>
	<4C0D5DCD.5010201@sandeen.net>
	<AANLkTik1T2nJxsoK9UGIVy6q6pfSxniFfJXJY0InmuUh@mail.gmail.com>
	<AANLkTil4FMnGl7llR4N0PkXuNyEClQmTspNK6PT62PAi@mail.gmail.com>
	<889B6B31-A1F0-438D-B782-DBB855912854@sandeen.net>
	<AANLkTilrmEnLrxRSYNnwr8vFaZi7R9U5vY39NmBWUEMy@mail.gmail.com>
	<C4177A0B-9A74-40E6-9A58-64418034232C@sandeen.net>
	<AANLkTinzZkN9agekI5eqzA9hERsghI7yDJyAy1O755dr@mail.gmail.com>
	<4C0DA955.7020802@sandeen.net>
	<AANLkTil3D5w9Cg2_8GmFa-i0szYmhAu61AXdaLvwp3xv@mail.gmail.com>
	<15142.1275975644@localhost>
Date: Tue, 8 Jun 2010 08:44:57 -0600
Message-ID: <AANLkTils-E5vnQaVg7ezQGIOi3rbzIfiS0l5Q1imMZb8@mail.gmail.com>
Subject: Re: EXT3 File System Corruption 2.6.34
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 11:40 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Mon, 07 Jun 2010 20:37:06 MDT, Jeffrey Merkey said:
>> Cool.  I'll use that from now on.  wonder if the source code came from
>> xdump 10 years ago ... LOL
>
> Probably not, given that 'man hexdump' says:
>
> BSD                             April 18, 1994                             BSD
>
> Plus, they obviously rolled the code for '-e formatstring' themselves, nobody
> could have been so desperate to steal that code. ;)
>
> hexdump -e '"%08.08_ax  " 4/4 "%08X " "  " 4/4 "%08x " ' -e '"  *" 32/1 "%_p"' -e '"*\n"'
>
> That's so old-skool it hurts. :)
>
>
>

LOL.  :)

Jeff
