Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758049Ab0DWQ1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:27:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:36489 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756690Ab0DWQ1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:27:06 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/oR6FAF9joH1SplDHna3IhohknzZTLIKeI/G0Ixx
	6ZjUFe1mWWE6g9
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: i915_do_wait_request BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Fri, 23 Apr 2010 18:27:02 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5; KDE/4.4.2; i686; ; )
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eric@anholt.net
References: <u2nc4e36d111004230324x7e19b794ifbf1ae3cc157ab2e@mail.gmail.com> <20100423090857.728960b7@virtuousgeek.org>
In-Reply-To: <20100423090857.728960b7@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004231827.02817.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Jesse Barnes wrote at 18:08:57
> On Fri, 23 Apr 2010 12:24:25 +0200
> 
> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
> > Hi
> > 
> > Just tried to boot current vanilla upstream kernel - and got pretty ugly 
> > oops. Here is serial console catch after X-startup:
> > 
> > 
> > BUG: unable to handle kernel NULL pointer dereference at (null)
> > IP: [<ffffffffa035de81>] i915_do_wait_request+0x101/0x4f0 [i915]
> > PGD 139649067 PUD 133b5a067 PMD 0
> > Oops: 0000 [#1] PREEMPT SMP
> > last sysfs file:
> > /sys/devices/virtual/backlight/acpi_video0/actual_brightness CPU 0
> > Modules linked in: xt_tcpudp bridge stp llc autofs4 sunrpc ipv6
> > ipt_REJECT xt_physdev xt_state ]
> 
> Here's the fix I'm testing now.
works fine here for the ThinkPAd T400.
Thx.



-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

