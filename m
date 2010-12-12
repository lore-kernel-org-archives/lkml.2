Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab0LLTAZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:00:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50856 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753596Ab0LLTAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:00:24 -0500
Date: Sun, 12 Dec 2010 19:00:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
Message-ID: <20101212190035.GA21207@opensource.wolfsonmicro.com>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-10-git-send-email-tj@kernel.org>
 <s5hk4jfbc94.wl%tiwai@suse.de>
 <4D0492CB.2010702@kernel.org>
 <s5hhbejb1yr.wl%tiwai@suse.de>
 <20101212124041.GD15189@opensource.wolfsonmicro.com>
 <4D04F211.6080602@kernel.org>
 <20101212184733.GB20358@opensource.wolfsonmicro.com>
 <4D05195A.8070107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D05195A.8070107@kernel.org>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 07:50:02PM +0100, Tejun Heo wrote:

> > For future reference please note that sound/soc is maintained as a
> > subtree of ALSA - if you could send patches to that separately to myself
> > and Liam as well as Takashi and Jaroslav that'd make life a little
> > easier.

> I can resplit and resend if necessary.  Takashi, do you wanna take the
> patch as-is or resplit?  Or shall I route it through wq tree?

No need, just merge it along with the rest of the patch however that's
going.  I was mentioning this for future reference rather than for the
present patch.

Liam, will the TWL6040 updates Magi posted the other day also be
affected?  I seem to remember they added the same pattern as WM835x has.
