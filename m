Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1ALPfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:35:54 -0500
Received: from kroah.org ([198.145.64.141]:40111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890Ab1ALPfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:35:52 -0500
Date: Tue, 11 Jan 2011 21:06:47 -0800
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        uclinux-dist-devel@blackfin.uclinux.org, stable@kernel.org,
        linux-kernel@vger.kernel.org, stable-review@kernel.org
Subject: Re: [stable] [PATCH] ASoC: Blackfin TDM: fix missed
 snd_soc_dai_get_drvdata update
Message-ID: <20110112050647.GA18268@kroah.com>
References: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:08:19PM -0500, Mike Frysinger wrote:
> One spot was missed in this driver when converting from
> snd_soc_dai.private_data to snd_soc_dai_get_drvdata.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Please read Documentation/stable_kernel_rules.txt for how to get patches
into the stable kernel tree (hint, add cc: stable in the signed-off-by
line).  Copying the patches to the stable and stable-review lists
(stable-review is only for the review of the stable releases) will cause
them to get lost as they aren't in Linus's tree yet, so I don't know the
git commit id of it.

Hope this helps,

greg k-h
