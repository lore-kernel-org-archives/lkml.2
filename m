Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379Ab1ILKty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 06:49:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56159 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751602Ab1ILKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 06:49:53 -0400
Date: Mon, 12 Sep 2011 11:49:51 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Julia Lawall <julia@diku.dk>, Liam Girdwood <lrg@ti.com>,
        kernel-janitors@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sound/soc/kirkwood/kirkwood-i2s.c: fix trivial build
 regression
Message-ID: <20110912104951.GC2953@opensource.wolfsonmicro.com>
References: <1313820761-12042-1-git-send-email-julia@diku.dk>
 <3099701.CcMbBAJgz4@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3099701.CcMbBAJgz4@wuerfel>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 11, 2011 at 08:07:30PM +0200, Arnd Bergmann wrote:
> A fix merged in 3.1-rc2 introduced a small regression, this should get it
> to build again.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thanks.

Please try to make sure that your commit logs match the style of the
subsystem.
