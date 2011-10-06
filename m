Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935783Ab1JFKRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:17:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53138 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757131Ab1JFKRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:17:00 -0400
Date: Thu, 6 Oct 2011 11:16:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Liam Girdwood <lrg@ti.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Replace remaining use of *_volsw_2r with *_volsw
Message-ID: <20111006101658.GC14518@opensource.wolfsonmicro.com>
References: <20111006132204.29c84ed7349daf8c4aa39c3b@canb.auug.org.au>
 <1317884352-17067-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317884352-17067-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 09:59:12AM +0300, Peter Ujfalusi wrote:
> The snd_soc_*_volsw_2r functionality has been merged to
> *volsw callbacks.
> Few places still used the get, or put variant of volsw_2r,
> replace those with the corresponding *_volsw.

Applied, thanks.
