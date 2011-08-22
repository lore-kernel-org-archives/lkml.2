Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1HVW3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 18:29:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43312 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753912Ab1HVW3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 18:29:47 -0400
Date: Mon, 22 Aug 2011 23:29:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia@diku.dk>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] sound/soc/kirkwood/kirkwood-i2s.c: add missing kfree
Message-ID: <20110822222944.GB30609@opensource.wolfsonmicro.com>
References: <1313820761-12042-1-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313820761-12042-1-git-send-email-julia@diku.dk>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 08:12:38AM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Adjust the goto to jump to the error handling code that includes kfree.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Applied, thanks.
