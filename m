Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab1FQS3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:29:45 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60633 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab1FQS3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:29:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mQ5UCazvzwA44CgdZq0c3gV8U003scKoyzJ6ZqHZ36wCdPQynHZfYubCGfHX2bkLPb
         2rSWf3p/4HP51Qk25Jk9rzoH3uH2pzmYViYgAl+1uysWOgARChchaOFiED1K40JwfgSS
         7dHYSuxzOQUl1ANBht6T5HxsUePETuNc3hopY=
MIME-Version: 1.0
In-Reply-To: <BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com>
References: <BANLkTin8b2suL1675DKvHbeXuCzeCFJeOg@mail.gmail.com>
	<BANLkTin-iYMvbuq=DGo8JZa_vYUMsd24jQ@mail.gmail.com>
Date: Fri, 17 Jun 2011 11:29:42 -0700
Message-ID: <BANLkTi=NYq7wFqGFuiM_QUtpEZDS5pAuUQ@mail.gmail.com>
Subject: Re: New Gentoo install on Intel Z68/i7-2600K system hangs after
 VFS:Mounted root...
From: Mark Knecht <markknecht@gmail.com>
To: Paul Hartman <paul.hartman@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 7:46 AM, Paul Hartman <paul.hartman@gmail.com> wrote:
> On Thu, Jun 16, 2011 at 10:11 PM, Mark Knecht <markknecht@gmail.com> wrote:
>>   I've got a Windows friend who's trying to make the jump to Gentoo
>> Linux. He's purchased a new motherboard & processor which I believe
>> are part of the new 'Sandy Bridge' family:
>>
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16813131730
>> http://www.newegg.com/Product/Product.aspx?Item=N82E16819115070
>>
>> I've installed Gentoo. The kernel is 2.6.38-gentoo-r6. The install
>> seemed to go fine. This is my first install from scratch after the
>> switch to OpenRC.
>>
>>   When the machine boots it makes it through mounting sda3 on root,
>> which looks OK to me, but then just hangs with no other messages. I've
>> posted a photo of what the screen looks like when it stops:
>>
>> http://www.flickr.com/photos/29328985@N03/5841311388/
>
> Hi Mark,
>
> Have you tried booting with acpi=off ?
>
> Also, since it's a new build, have you done a memory test to be sure
> it is stable? Getting the RAM timings/voltages right is usually one of
> the biggest hurdles in building a new machine in my experiences.
>

Paul,
   We ran memtest86 for an hour. Completed a couple of passes with no
errors. Will run more later but no obvious memory problems seen.

   I installed 2.6.39-gentoo-r1. No change from 2.6.38-gentoo-r6.
Stops at the same place.

   I tried 2.6.39-gentoo-r1 with no kernel options, and with all
combinations of nousb and acpi=off. All 4 attempts quit at the same
place.

   This is an interesting failure that I've never seen before.
Generally either you don't find the root drive at all, or you do and
get into init where it fails somewhere. To have it just stop is quite
strange.

   I've suggested that the guy with the machine try installing a
prepackaged distro, Ubuntu or Redhat, just to see if they have the
secret sauce or not. If one of those works then we're closer to
determining why my Gentoo install didn't.

   I need to investigate what used to be debug through the serial port
but I think now is done through Ethernet? Maybe we can catch more of
the boot info if the error is actually earlier and we're just not
catching it because we cannot scroll back.

   Any other ideas warmly welcomed.

Cheers,
Mark
