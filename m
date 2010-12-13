Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0LMN3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 08:29:10 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34529 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab0LMN3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 08:29:08 -0500
Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>
In-Reply-To: <s5h7hfe5aw2.wl%tiwai@suse.de>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	 <1292086307-19211-10-git-send-email-tj@kernel.org>
	 <s5hk4jfbc94.wl%tiwai@suse.de> <4D0492CB.2010702@kernel.org>
	 <s5hhbejb1yr.wl%tiwai@suse.de>
	 <20101212124041.GD15189@opensource.wolfsonmicro.com>
	 <s5h7hfe5aw2.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 13:29:03 +0000
Message-ID: <1292246943.3320.59.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 09:34 +0100, Takashi Iwai wrote:
> At Sun, 12 Dec 2010 12:40:41 +0000,
> Mark Brown wrote:
> > 
> > On Sun, Dec 12, 2010 at 01:38:36PM +0100, Takashi Iwai wrote:
> > 
> > > Meanwhile, I wondered whether it's the really wanted behavior for
> > > that particular code path, thus the previous question to Liam.
> > 
> > Yes, it's desired behaviour.  That's what the old code was trying to do.
> 
> OK, now I merged to sound git tree.
> Also it's merged back to topic/asoc branch with a conflict fix.
> Please pull appropriately.
> 
> (I still don't remember why it had to be flush_work_sync() instead
>  of cancel_work_sync() in the remove callback path for ASoC, though...
>  Both aren't so much different nowadays and should work fine in such a
>  case, though :)

Fwiw, I can't remember either why it had to be flush_work_sync() here.
The initial soc-core stuff was 5 years ago and the reason is well and
truly forgotten ;-)

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

