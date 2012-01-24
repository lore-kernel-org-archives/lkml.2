Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2AXLex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 06:34:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41168 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab2AXLev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 06:34:51 -0500
Date: Tue, 24 Jan 2012 11:34:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: ASoC: Fix use-after-free in wm2000 - don't release_firmware()
 twice
Message-ID: <20120124113449.GA14888@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1201232224250.8772@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201232224250.8772@swampdragon.chaosbits.net>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 10:28:44PM +0100, Jesper Juhl wrote:
> In wm2000_i2c_probe(), if we take the true branch in

Applied, thanks.
