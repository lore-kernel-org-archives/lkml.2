Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab0LMNcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:32:35 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60501 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab0LMNce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:32:34 -0500
Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Olaya, Margarita" <magi.olaya@ti.com>
Cc: Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <20101212190035.GA21207@opensource.wolfsonmicro.com>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	 <1292086307-19211-10-git-send-email-tj@kernel.org>
	 <s5hk4jfbc94.wl%tiwai@suse.de> <4D0492CB.2010702@kernel.org>
	 <s5hhbejb1yr.wl%tiwai@suse.de>
	 <20101212124041.GD15189@opensource.wolfsonmicro.com>
	 <4D04F211.6080602@kernel.org>
	 <20101212184733.GB20358@opensource.wolfsonmicro.com>
	 <4D05195A.8070107@kernel.org>
	 <20101212190035.GA21207@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 13:32:29 +0000
Message-ID: <1292247149.3320.64.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-12 at 19:00 +0000, Mark Brown wrote:
> On Sun, Dec 12, 2010 at 07:50:02PM +0100, Tejun Heo wrote:
> 
> > > For future reference please note that sound/soc is maintained as a
> > > subtree of ALSA - if you could send patches to that separately to myself
> > > and Liam as well as Takashi and Jaroslav that'd make life a little
> > > easier.
> 
> > I can resplit and resend if necessary.  Takashi, do you wanna take the
> > patch as-is or resplit?  Or shall I route it through wq tree?
> 
> No need, just merge it along with the rest of the patch however that's
> going.  I was mentioning this for future reference rather than for the
> present patch.
> 
> Liam, will the TWL6040 updates Magi posted the other day also be
> affected?  I seem to remember they added the same pattern as WM835x has.

Not sure myself.

Magi, could you check your patch queue for any use of
flush_scheduled_work() here ?

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

