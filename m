Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0LLMka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 07:40:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39244 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752448Ab0LLMka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 07:40:30 -0500
Date: Sun, 12 Dec 2010 12:40:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
Message-ID: <20101212124041.GD15189@opensource.wolfsonmicro.com>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-10-git-send-email-tj@kernel.org>
 <s5hk4jfbc94.wl%tiwai@suse.de>
 <4D0492CB.2010702@kernel.org>
 <s5hhbejb1yr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hhbejb1yr.wl%tiwai@suse.de>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 01:38:36PM +0100, Takashi Iwai wrote:

> Meanwhile, I wondered whether it's the really wanted behavior for
> that particular code path, thus the previous question to Liam.

Yes, it's desired behaviour.  That's what the old code was trying to do.
I've not seen the original patch, could someone resend it to me please
(or send a pointer)?
