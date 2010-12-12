Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab0LLSrW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 13:47:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47911 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753777Ab0LLSrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 13:47:21 -0500
Date: Sun, 12 Dec 2010 18:47:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tejun Heo <tj@kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
Message-ID: <20101212184733.GB20358@opensource.wolfsonmicro.com>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
 <1292086307-19211-10-git-send-email-tj@kernel.org>
 <s5hk4jfbc94.wl%tiwai@suse.de>
 <4D0492CB.2010702@kernel.org>
 <s5hhbejb1yr.wl%tiwai@suse.de>
 <20101212124041.GD15189@opensource.wolfsonmicro.com>
 <4D04F211.6080602@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D04F211.6080602@kernel.org>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 12, 2010 at 05:02:25PM +0100, Tejun Heo wrote:

> Weirdly, lkml seemed to have eaten the original postings.  I can't
> find them in any archive.  The following is the original patch.

Possibly too big or something?

>   http://git.kernel.org/?p=linux/kernel/git/tj/wq.git;a=commitdiff;h=01f8126c2e14245cf0ba11a25fb9a291710066e1;hp=cd591981a8d06d6aaca6d7ef2412d12a7adf47ed

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

For future reference please note that sound/soc is maintained as a
subtree of ALSA - if you could send patches to that separately to myself
and Liam as well as Takashi and Jaroslav that'd make life a little
easier.
