Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485Ab1FUAfM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:35:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54316 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755808Ab1FUAfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:35:10 -0400
Date: Tue, 21 Jun 2011 01:35:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Clemens Ladisch <clemens@ladisch.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] firmware: Make firmware drivers generally available
Message-ID: <20110621003507.GG1905@opensource.wolfsonmicro.com>
References: <20110617103218.GA29723@opensource.wolfsonmicro.com>
 <1308310831-27861-1-git-send-email-lars@metafoo.de>
 <4DFB53B3.8070806@ladisch.de>
 <BANLkTimWfT_LSLX36oLcSSYNqi4buBiJUQ@mail.gmail.com>
 <4DFB98EE.9000609@ladisch.de>
 <BANLkTi=idGOgMkBXF6p-Uo9ARAmgb1uR_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTi=idGOgMkBXF6p-Uo9ARAmgb1uR_g@mail.gmail.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 02:25:21PM -0400, Mike Frysinger wrote:
> On Fri, Jun 17, 2011 at 14:11, Clemens Ladisch wrote:

> > "drivers/firmware" is the obvious name for both, but that makes
> > it ambiguous.  I'd suggest to split the two subsystems into
> > "drivers/host-firmware" and "drivers/device-firmware".

> i honestly dont see how this is better.  the drivers/firmware/ isnt
> exactly overflowing, and differentiating between the two modes doesnt
> seem to gain us anything.

Do we have anything like an actual subsystem in firmware?  If we do and
it's sensible to do things that affect all firmwares then splitting
seems reasonable but if not then it's less clear.
