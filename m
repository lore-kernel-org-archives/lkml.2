Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0E3Tkw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 15:40:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51561 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0E3Tku convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 15:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p0s/s2e6weql8w+z8HeZa5LqJtR6ecMPLH6LZUskkHZDkVr4gheE0JBIN/t7Q4GzOi
         RQS/6HqLIesFtrGuVmol4lI2vE5mwYiTj55S2ZejCT8sxouF0MWQtUfLjwIYlppYItXC
         LUhz2f9yODnTuNHYxxT2h1iwtj7rmPUjvbn44=
MIME-Version: 1.0
In-Reply-To: <201005301333.51149.tfjellstrom@strangesoft.net>
References: <201005292046.06344.tfjellstrom@strangesoft.net>
	<4C02B104.4010900@gmail.com>
	<201005301257.31839.tfjellstrom@strangesoft.net>
	<201005301333.51149.tfjellstrom@strangesoft.net>
Date: Sun, 30 May 2010 13:40:49 -0600
Message-ID: <AANLkTilSg8KZc2ZNobxQUnU105ADOeyxTAvJ3vFvbqEC@mail.gmail.com>
Subject: Re: via 8237 sata errors
From: Robert Hancock <hancockrwd@gmail.com>
To: Thomas Fjellstrom <tfjellstrom@strangesoft.net>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 1:33 PM, Thomas Fjellstrom
<tfjellstrom@strangesoft.net> wrote:
> On May 30, 2010, Thomas Fjellstrom wrote:
>> On May 30, 2010, Robert Hancock wrote:
>> > On 05/29/2010 08:46 PM, Thomas Fjellstrom wrote:
>> > > I'm getting a rather nasty set of messages from dmesg when trying to
>> > > use a couple SATA II WD 2TB Green drives with an older system (via
>> > > 8237 based). They seem to work fine on a newer p35 based system.
>> >
>> > ..
>> >
>> > > [  283.308963] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action
>> > > 0x0 [  283.309007] ata2.00: BMDMA stat 0x4
>> > > [  283.309045] ata2.00: failed command: READ DMA
>> > > [  283.309089] ata2.00: cmd c8/00:08:08:08:30/00:00:00:00:00/e0 tag 0
>> > > dma 4096 in [  283.309091]          res
>> > > 41/04:00:08:08:30/00:00:00:00:00/e0 Emask 0x1 (device error) [
>> > > 283.309171] ata2.00: status: { DRDY ERR }
>> > > [  283.309207] ata2.00: error: { ABRT }
>> > > [  283.324886] ata2.00: configured for UDMA/133
>> > > [  283.324904] ata2: EH complete
>> >
>> > It's not really clear why the drive is returning command aborted on a
>> > read, there's no other error bits to indicate an uncorrectable error or
>> > a CRC error. Is it only the one drive that's giving the errors?
>>
>> I'm not entirely sure if its the same drive each time. I can make sure
>> today. The fun part is it works fine in a different machine. Where as it
>> will start erroring out like that almost right away in the via based
>> machine. When its doing that, its also making some fairly scary (for a
>> hard drive) noises, but since it doesn't do that in the p35 machine I'm
>> really hoping it isn't the drive.
>
> I've started up a dd on each drive, just for kicks, and reading from both of
> them at the same time seems to work fine on the via chipset. Given this
> little tid-bit, it seems its only once md-raid is setup on the drives does
> one of them freak out.

If the problem happens mostly when both drives are in use then it
could be a power supply issue. Some drives are rather sensitive to
power fluctuations. You could try and move the drives to separate
power cables if they're on the same one, or maybe the power supply's
just not up to snuff.
