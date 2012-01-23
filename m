Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409Ab2AWVLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 16:11:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57306 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754179Ab2AWVLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 16:11:11 -0500
Date: Mon, 23 Jan 2012 21:11:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] Sound WM8958 DSP2: Use correct format string in
 dev_err() call
Message-ID: <20120123211107.GD26409@opensource.wolfsonmicro.com>
References: <alpine.LNX.2.00.1201232113400.8772@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201232113400.8772@swampdragon.chaosbits.net>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 09:15:48PM +0100, Jesper Juhl wrote:
> To print a value of type size_t one should use %zd, not %d.

Applied, thanks, but please do at least try to use a subject line in the
style for the subsystem.
