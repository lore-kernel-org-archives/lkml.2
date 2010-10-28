Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0J1NNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:13:34 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:37995 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758661Ab0J1NNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:13:32 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19phN4Z7CFpfG3xIIRH3NAgODUdvbRNfakOhXDhPp
	IeKuH3ea4OBm87
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: kmemleak disabled itself in 2.6.36
Date: Thu, 28 Oct 2010 15:13:25 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <lrodriguez@atheros.com>
References: <201010272112.59520.toralf.foerster@gmx.de> <1288254789.10238.5.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1288254789.10238.5.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010281513.26185.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Catalin Marinas wrote at 10:33:09
> On Wed, 2010-10-27 at 20:12 +0100, Toralf Förster wrote:
> > I'm unsure whether this happens due to a
> > $> sudo su -c "echo clear > /sys/kernel/debug/kmemleak"
> > or while regular scanning, but anyway seems not to be normal, or ?
> > 
> > 2010-10-27T20:42:21.697+02:00 n22 kernel: flush-254:0: page allocation
> > failure. order:0, mode:0x0
> 
> [...]
> 
> > 2010-10-27T20:42:21.699+02:00 n22 kernel: kmemleak: Cannot allocate a
> > kmemleak_object structure 2010-10-27T20:42:21.699+02:00 n22 kernel: Pid:
> > 15475, comm: flush-254:0 Not tainted 2.6.36 #2
> 
> [...]
> 
> > 2010-10-27T20:42:21.700+02:00 n22 kernel: kmemleak: Kernel memory leak
> > detector disabled
> 
> Are you running out of memory on your system? Kmemleak tried to allocate
> a structure but the slab allocator failed to get page. Kmemleak disables
> itself in such situations but the problem is somewhere else (not enough
> memory?).
> 
> Catalin

I don't think so - no big load to that system, no excessive compiler runs ...

-- 
MfG/Kind regards
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

