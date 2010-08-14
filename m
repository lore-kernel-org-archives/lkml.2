Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0HNPk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 11:40:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45920 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0HNPk4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 11:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=hritpw5+CjbJW/hSibvJeKB7YoElbY96sYR9ifTmHRfxsmYk2ua9rFOiYraxp6jFSx
         zPauotAiOcSn7C+vKGsu8o61+6tmGVDRltOGBQW9d5lwwRda4XCTXXvnHhDg0jj0KOv5
         dUuTOWGgpjrkgjTB7OP4gLDrILTrxV74+26VI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20100814134254.GC17430@suse.de>
References: <AANLkTi=YL_VKKDU8ok=OYotPhyQcGsVB2O-PU29+70YT@mail.gmail.com>
	<20100814134254.GC17430@suse.de>
Date: Sat, 14 Aug 2010 17:40:55 +0200
Message-ID: <AANLkTi=+=2GEiC_WASfxC2u_xeTe4xdrZzLBs5Q1j3b7@mail.gmail.com>
Subject: Re: Call traces w/ 2.6.35.2 (not w/ 2.6.35.1 plus 2.6.35.2-rc1)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, wylda@volny.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 3:42 PM, Greg KH <gregkh@suse.de> wrote:
> On Sat, Aug 14, 2010 at 08:20:26AM +0200, Sedat Dilek wrote:
>> Hi Greg,
>>
>> looks like 2.6.35.2 misses some fixes from 2.6.35.2-rc1?
>
> Huh?  I don't understand what you are trying to show here at all.
>
>> sd@tbox:~/src/linux-2.6/patches/upstream$ cat patch-2.6.35.1
>> patch-2.6.35.2-rc1 > new.patch
>>
>> sd@tbox:~/src/linux-2.6/patches/upstream$ grep "diff --git" new.patch | wc -l
>> 132
>>
>> sd@tbox:~/src/linux-2.6/patches/upstream$ grep "diff --git"
>> patch-2.6.35.2 | wc -l
>> 128
>>
>> Unfortunately, a kernel patched w/ 2.6.35.2 causes Call traces here.
>
> And these are also showing up on Linus's tree right now as well?  Have
> you reported them?
>

Shall I open a separate BR for 2.6.35-gitX?
I can confirm the problem occured in the first time in git12 (saw it
in git14 and git15).

As I have currently a slow system, I won't do a bisect or X-times
kernel-builds, sorry for that.
Each build takes me around 2hrs.

- Sedat -
