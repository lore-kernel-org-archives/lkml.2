Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab1LKC7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 21:59:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53446 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab1LKC7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 21:59:42 -0500
Date: Sun, 11 Dec 2011 10:59:16 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 4/5] ASoC: mxs: Add missing MODULE_LICENSE("GPL")
Message-ID: <20111211025915.GD2800@opensource.wolfsonmicro.com>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <a541450341a475b27ef603c5a4a67f113ba7fa0c.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a541450341a475b27ef603c5a4a67f113ba7fa0c.1323436034.git.LW@KARO-electronics.de>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 02:38:11PM +0100, Lothar Waßmann wrote:
> The sound driver refuses to load as module, because of the missing
> MODULE_LICENSE("GPL").
> The file header indicates that the driver is indeed published under
> the GPL.

Applied, thanks.
