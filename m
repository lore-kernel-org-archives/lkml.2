Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759560Ab1FQSJB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 14:09:01 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59504 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759548Ab1FQSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 14:08:58 -0400
X-Sasl-enc: Byp5qAx8Br0E+0zBEdEuh2DSUvsTTBiW/y21fuqy8NNr 1308334136
Message-ID: <4DFB98EE.9000609@ladisch.de>
Date: Fri, 17 Jun 2011 20:11:58 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] firmware: Make firmware drivers generally available
References: <20110617103218.GA29723@opensource.wolfsonmicro.com> <1308310831-27861-1-git-send-email-lars@metafoo.de> <4DFB53B3.8070806@ladisch.de> <BANLkTimWfT_LSLX36oLcSSYNqi4buBiJUQ@mail.gmail.com>
In-Reply-To: <BANLkTimWfT_LSLX36oLcSSYNqi4buBiJUQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Fri, Jun 17, 2011 at 09:16, Clemens Ladisch wrote:
> > It looks as if sigma.c doesn't actually belong into drivers/firmware.
> > That directory is for code that lets the kernel access the firmware
> > of the platform that the kernel itself runs on.
> 
> -EMISSINGBETTERSUGGESTION

I *knew* somebody would ask.  :)

"drivers/firmware" is the obvious name for both, but that makes
it ambiguous.  I'd suggest to split the two subsystems into
"drivers/host-firmware" and "drivers/device-firmware".


Regards,
Clemens
