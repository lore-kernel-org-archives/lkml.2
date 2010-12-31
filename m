Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab0LaWLK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 17:11:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38679 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753902Ab0LaWLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 17:11:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=maZX3G4e1cqp/8tQI0Uurn989RGTTHFP7vAmptOsw1iIAVRtzBoS10bLdX8POFYkr4
         vntUVj3B6lD80vQ457gbjAm3kCmskj48znyQkJ4IQzyh9UzGoDW8n0CRCVhsZSVyJh+e
         qs47FLbLGw60rgtY/S7sh4zUC5woaW3rlXAJE=
MIME-Version: 1.0
In-Reply-To: <20110101000558.56c77a55@janini.home>
References: <20101231193858.2c742025@janini.home> <20101231103345.baba0f8c.rdunlap@xenotime.net>
 <20101231212800.1e47f200@janini.home> <20101231113954.dc9adbdf.rdunlap@xenotime.net>
 <20101231234010.0165f0e8@janini.home> <AANLkTi=GY+ZFNMCdCQAj7aL6smUmiJZ=a-kcc76EECj7@mail.gmail.com>
 <20110101000558.56c77a55@janini.home>
From: Avery Pennarun <apenwarr@alumnit.ca>
Date: Fri, 31 Dec 2010 14:10:48 -0800
X-Google-Sender-Auth: DpgnHH4Ck59LJvcwcQ8iiiHC45E
Message-ID: <AANLkTi=0nGnr9Hp9RuXpRJjCvoHxK-DsYgK3AWa3Rr5w@mail.gmail.com>
Subject: Re: APM_CONFIG on x86 - Is it possible?
To: yotam.medini@gmail.com
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 31, 2010 at 2:05 PM, Yotam Medini <yotam.medini@gmail.com> wrote:
> On Fri, 31 Dec 2010 13:54:59 -0800
> Avery Pennarun <apenwarr@alumnit.ca> wrote:
>> > I do get:
>> >
>> >  $ sudo modprobe apm
>> >  FATAL: Error inserting apm
>> >    (/lib/modules/2.6.32.yumax/kernel/arch/x86/kernel/apm.ko): No such device
>>
>> The output of 'dmesg' might be revealing here.  However, it's likely
>> that your PC doesn't actually support APM unless it's *very* old.  You
>> might want to try ACPI instead.
>
> Indeed:
>    $ dmesg  | grep -i apm
>    [   52.897795] apm: BIOS not found.
> I will try to investigate this.
>
> But I clearly remember that a few years ago, I could issue:
>    $ cat /proc/apm
> and see the battery status.
> Then, I believe, the kernel tree used to have arch/i386.

arch/i386 is named arch/x86 nowadays.

It might be interesting to try an older kernel and see if you get
different results.  Since APM is so rare nowadays, I wouldn't be
surprised to find out that the kernel has accumulated some bugs there
in the intervening years.

Avery
