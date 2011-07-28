Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575Ab1G1NpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:45:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35841 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab1G1NpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:45:20 -0400
Date: Thu, 28 Jul 2011 14:44:52 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
Message-ID: <20110728134452.GA829@flint.arm.linux.org.uk>
References: <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com> <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com> <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com> <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com> <1311740499.1536.56.camel@vkoul-udesk3> <CAJe_ZhfaPfobs5P+q+t-kRSK4fAvm-v_brYgqmco8fwOOBeT8A@mail.gmail.com> <1311757347.1536.103.camel@vkoul-udesk3> <CAJe_Zhd+Z4-=xDzFrd3ARuKZkUAo6n_miQgdSADY9Uk6uhkqhw@mail.gmail.com> <20110727203710.GB5028@flint.arm.linux.org.uk> <CAJe_ZhfNHQYOvG2_qr3FeZfL-PDmOX2TS9r=2LokoKq=U3UcLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJe_ZhfNHQYOvG2_qr3FeZfL-PDmOX2TS9r=2LokoKq=U3UcLQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 04:26:25PM +0530, Jaswinder Singh wrote:
> On 28 July 2011 02:07, Russell King <rmk@arm.linux.org.uk> wrote:
> > On Wed, Jul 27, 2011 at 08:00:23PM +0530, Jaswinder Singh wrote:
> >> On 27 July 2011 14:32, Koul, Vinod <vinod.koul@intel.com> wrote:
> >> > You can have two different DMACs in same system. At least I have two
> >> > from current intel_mid_dma which are used. Both give their channel id
> >> > starting from 0, 1....
> >> > Further as we integrate video, audio, spi, emmc dmacs possibility of
> >> > having multiple dmacs will increase in a system
> >>
> >> Most of Samsung's S5P series have 3 DMACs - 2 for peripherals and 1 for
> >> mem->mem But that is not the point.
> >>
> >> This patch in no way affects what values currently a dmac driver
> >> assigns to chan_id
> >
> > Then *explain* how the chan_id is used to match the channel which the
> > peripheral requires when you have three DMA controllers, each with
> > channels numbered 0 to 7.
> >
> >> > Sorry I didn't get you.
> >> > As I understand you are trying to simplify the filter function by
> >> > assigning unique ids to all channels,
> >>
> >> No dear. Let me put it precisely.
> >>
> >> Even if we make no further change to the dmaengine, this patch is the right
> >> thing to do today.
> >
> > You sound like a politician.  "the right thing to do" is a cop-out.  That
> > says "believe me, I know I'm right, but I can't say why I'm right, I just
> > am."  Basically, it means that the person saying it has no clue on the
> > subject they're talking about.
> 
> Why don't you look at the _patch_ and see if it's correct or not ?
> Rather than passing judgement on my character.

Oh for fuck sake, this is absolutely useless.  I gave you specific examples
to explain your idea.  You refuse to do so.  So my conclusion is that your
idea can not satisfy those scenarios.

As my examples are based on _real_ boards which I have here, the conclusion
I come to is that your idea is completely unworkable and so doesn't warrant
even reading the code.

That's not passing judgement on your character.

Your complete refusal to explain how your idea applies to my example cases
does _by_ _itself_ pass a judgement on your character.  It doesn't require
any personal involvement on my part to achieve that.

So, all in all I am no longer interested in your obviously unworkable
solution.  So I say NAK to it _until_ you can provide me with the
explaination I've asked for.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
