Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab0CXOEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:04:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33194 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755946Ab0CXOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:04:48 -0400
Date: Wed, 24 Mar 2010 14:04:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dan Carpenter <error27@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Joonyoung Shim <jy0922.shim@samsung.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] wm8994: playback => capture
Message-ID: <20100324140445.GD26453@rakim.wolfsonmicro.main>
References: <20100324115834.GG21571@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324115834.GG21571@bicker>
X-Cookie: Santa Claus is watching!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 02:58:34PM +0300, Dan Carpenter wrote:
> Sparse caught that initialize "playback" two times instead of
> initializing "capture".
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Applied, thanks.
