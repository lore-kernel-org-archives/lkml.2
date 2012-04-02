Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2DBQ6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:58:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37291 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2DBQ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:58:21 -0400
Date: Mon, 2 Apr 2012 17:57:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Rabin Vincent <rabin@rab.in>,
        Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC v2] ARM: amba: Remove AMBA level regulator support
Message-ID: <20120402165742.GD24211@n2100.arm.linux.org.uk>
References: <1333306720-28344-1-git-send-email-broonie@opensource.wolfsonmicro.com> <CACRpkdYRStgKo_e-4kZKA-V-OoMiV21jRS3R4g1Cq+4c+4=iQA@mail.gmail.com> <CAH+eYFC+q4xFuSdRBkO9nb0XZWU4pQ_yCyinMy2X3ds9WQd1kw@mail.gmail.com> <CACRpkda2zh=zR+A9bwhRXYHtQdFeUpiqG4d5g1i82mPCs1mXaQ@mail.gmail.com> <20120402101427.GA3172@opensource.wolfsonmicro.com> <20120402104357.GB24211@n2100.arm.linux.org.uk> <20120402113413.GA7560@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120402113413.GA7560@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 12:34:13PM +0100, Mark Brown wrote:
> On Mon, Apr 02, 2012 at 11:43:57AM +0100, Russell King - ARM Linux wrote:
> > On Mon, Apr 02, 2012 at 11:14:28AM +0100, Mark Brown wrote:
> 
> > > I was waiting for some pronouncement from Russell - looking at the git
> > > logs it seems the patch tracker is the normal way to merge things.
> 
> > Well, this stuff was invented by Linus, so its Linus' decision about
> > how to deal with the power control.
> 
> Linus already acked the patch, the question was more about how to get it
> merged.  Since most of the AMBA changes seem to go via your tree I've
> just submitted it to the patch system as 7366/1.

Does:

ARM PRIMECELL BUS SUPPORT
M:      Russell King <linux@arm.linux.org.uk>
S:      Maintained
F:      drivers/amba/
F:      include/linux/amba/bus.h

not provide enough clues?  Should I delete all my entries in that file
because the only people who look in there are spammers when the file is
published on the web?
