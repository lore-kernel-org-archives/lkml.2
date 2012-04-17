Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2DQSPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:15:45 -0400
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:46144 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755068Ab2DQSPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:15:44 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH 3/4] Add Wolfson Microelectronics WM8776 codec ALSA driver
Date: Tue, 17 Apr 2012 20:15:06 +0200
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org> <20120417170431.GT6652@opensource.wolfsonmicro.com> <s5h3982p71g.wl%tiwai@suse.de>
In-Reply-To: <s5h3982p71g.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201204172015.14582.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 April 2012 20:06:19 Takashi Iwai wrote:
> At Tue, 17 Apr 2012 18:04:31 +0100,
>
> Mark Brown wrote:
> > On Tue, Apr 17, 2012 at 06:52:49PM +0200, Takashi Iwai wrote:
> > > Mark Brown wrote:
> > > > This isn't just adding something into a specific driver which fails
> > > > at abstraction, it's adding generic code.  If it were adding
> > > > something to the ice17xx driver then that'd be one thing but look at
> > > > the subject line and location of the file...  this stuff should be
> > > > buried inside the driver if it's too painful to make the driver sane.
> > >
> > > The codes in sound/i2c are mostly oly for ice1712/ice1724 drivers
> > > after all...  They could be used by others, but I don't think there
> > > will be any more at this point.
> >
> > If they're specific to that driver we should make them specific to that
> > driver and make sure the pain is confined there.  We really don't want
> > to end up going back to the bad old days of having to do per-CPU/card
> > drivers for CODECs because nobody had thought to abstract this stuff,
> > that just makes everyone miserable.
> >
> > Looking at these commits I'd not expect anyone to figure out that this
> > isn't how we want or expect people to add generic CODEC drivers.
>
> Yeah, these stuff can be better put in pci/ice1712/ directory only
> for ice1724 driver.  In that way, you can avoid unnecessary exported
> symbols, too.

Xonar (oxygen) has a private version of these drivers too. It could be 
converted to use common code instead.

-- 
Ondrej Zary
