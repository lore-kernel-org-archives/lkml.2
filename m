Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389Ab0DHKyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:54:15 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:16766 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab0DHKyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:54:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MaCDyUEYrKVogOF+WC3OZ/mnYCQdPCqe6WRTncsMeol8q7siy/q4gn7u6jZCYd09JZ
         UwAoKmIkWxBHyBentck58RWmgb9RJB6w/yEczOLTlDpMpsLeRuwFShyvDeDwoFTDHNkV
         a18i/ZscUYsdPAGs1ZJngwG+GPLkRQdXFYuiw=
MIME-Version: 1.0
In-Reply-To: <20100408044409.GA14982@elf.ucw.cz>
References: <20100313122754.GD2192@elf.ucw.cz> <20100401060624.GA1329@ucw.cz> 
	<201004072226.34272.maciej.rutecki@gmail.com> <201004072252.08354.marek.vasut@gmail.com> 
	<20100408044409.GA14982@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 8 Apr 2010 18:53:53 +0800
Message-ID: <i2mf17812d71004080353oa8459642v33f88993eee87a99@mail.gmail.com>
Subject: Re: [regression] 2.6.34-rc1 to -rc3 on zaurus: no longer boots
To: Pavel Machek <pavel@ucw.cz>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-arm-kernel@lists.infradead.org,
       maciej.rutecki@gmail.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
       thommycheck@gmail.com, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       kernel list <linux-kernel@vger.kernel.org>, utx@penguin.cz,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 8, 2010 at 12:44 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2010-04-07 22:52:08, Marek Vasut wrote:
>> Dne St 7. dubna 2010 22:26:34 Maciej Rutecki napsal(a):
>> > On czwartek, 1 kwietnia 2010 o 08:06:25 Pavel Machek wrote:
>> > > Hi!
>> > >
>> > > > > I tried compiling 2.6.34-rc1, and it does not boot :-(. It does not
>> > > > > seem to even reset the framebuffer (I'm using kexec -- so it stays
>> > > > > stuck on on previous screen).
>> > >
>> > > Tried again with -rc2 and -rc3, and neither boots :-(. I did not have
>> > > time to set up serial console, yet :-(. Any ideas?
>> >
>> > I created a Bugzilla entry at
>> > https://bugzilla.kernel.org/show_bug.cgi?id=15712
>> > for your bug report, please add your address to the CC list in there,
>> >  thanks!
>> >
>> Pavel, you broke it ... and here you say something about sane arm maintainers
>> ;-)
>
> ? You know which patch causes it ?

Just have some time to try this out on my corgi, and the kernel runs
happily.

Pavel,

Which exact model are you running your kernel?
