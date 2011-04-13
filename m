Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab1DMAik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:38:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53961 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757163Ab1DMAij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:38:39 -0400
Date: Tue, 12 Apr 2011 17:38:47 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ASoC: Call snd_soc_new_widgets() after registering
 cards DAPM widgets
Message-ID: <20110413003847.GC24267@opensource.wolfsonmicro.com>
References: <1302629465-21315-1-git-send-email-lars@metafoo.de>
 <1302629465-21315-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302629465-21315-2-git-send-email-lars@metafoo.de>
X-Cookie: So this is it.  We're going to die.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 07:31:02PM +0200, Lars-Peter Clausen wrote:
> After registering new DAPM widgets nd_soc_new_widgets() must be called,
> otherwise DAPM for those new widgets will not work.
> 
> snd_soc_new_widgets() is placed after the card late_probe call, so cards
> can register new DAPM widgets in there.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

There's already a call for this in post_component_init(), it just needs
to be moved later in the sequence now.
