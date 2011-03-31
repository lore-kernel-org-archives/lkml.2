Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab1CaNjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:39:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:55323 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620Ab1CaNjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:39:53 -0400
Date: Thu, 31 Mar 2011 15:39:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Bill Gatliff <bgat@billgatliff.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <AANLkTikd_JRxmB_OWZqq178=K3bnxhdDqcNbgFNRtTyU@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1103311411090.22418@localhost6.localdomain6>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <20110331001502.GB6680@n2100.arm.linux.org.uk> <AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com> <AANLkTik-BFTzyPLuYVdhCJPocc0wPY0rKvO7BQS4Fg1S@mail.gmail.com> <AANLkTikd_JRxmB_OWZqq178=K3bnxhdDqcNbgFNRtTyU@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-327262446-1301574738=:22418"
Content-ID: <alpine.LFD.2.00.1103311534310.22418@localhost6.localdomain6>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-327262446-1301574738=:22418
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1103311534311.22418@localhost6.localdomain6>

On Wed, 30 Mar 2011, Linus Torvalds wrote:

> On Wed, Mar 30, 2011 at 6:15 PM, Bill Gatliff <bgat@billgatliff.com> wrote:
> >
> > I'm not sure this metric is completely fair to ARM.  If you want to
> > level the field, I think you have to divide each result by the number
> > of SoC's
> 
> But that's the problem with ARM. Hardware companies that do one-off
> stuff, with no sense of compatibility.
> 
> And calling it an "opportunity" is just stupid.
> 
> There's nothing good about causing extra work just because ARM hasn't
> had the sense to standardize on one (or a couple) of interrupt
> controllers etc.

Well, ARM is not the only one there, it's the top one, but mips and
power are not less crazy. Here are the top five architectures counted
in number of irq_chip implementations.

      arch/arm     139
      arch/mips    75
      arch/powerpc 44
      arch/alpha   21
      arch/x86     15

Thanks,

	tglx
---1463795968-327262446-1301574738=:22418--
