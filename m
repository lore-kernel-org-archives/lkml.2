Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934911Ab2J3XO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:14:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40853 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400Ab2J3XO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:14:26 -0400
Date: Tue, 30 Oct 2012 16:11:25 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: yongd <yongd@marvell.com>
Cc: Chris Ball <cjb@laptop.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Daniel Drake <dsd@laptop.org>, Sascha Hauer <s.hauer@pengutronix.de>,
        Wilson Callan <wilson.callan@savantsystems.com>,
        Ben Dooks <ben-linux@fluff.org>, zhangfei.gao@marvell.com,
        kevin.liu@marvell.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/3] mmc: remove MMC_CAP_NEEDS_POLL setting in
 sdhci_add_host
Message-ID: <20121030231124.GA2902@lizard>
References: <1351589403-26398-1-git-send-email-yongd@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351589403-26398-1-git-send-email-yongd@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 05:30:00PM +0800, yongd wrote:
> Sorry for my so late. And eventually these updated patches are here for your
> review. Thanks in advance.
> For patch 1, add SDHCI_QUIRK_BROKEN_CARD_DETECTION setting for ESDHC_CD_GPIO type,
> or the host controller detection interrupts will be redundantly enabled. And its
> comment is correspondingly updated.
> For patch 2, broaden SDHCI_QUIRK_BROKEN_CARD_DETECTION setting for all detection
> types except S3C_SDHCI_CD_INTERNAL. Then also update the comment.
> For patch 3, no update.

They all look OK, but note that I did not check drivers' logic, so I hope
you carefully reviewed all the drivers yourself. :)

Unfortunately, you decided to go the dangerous way, instead of taking my
100%-safe approach (i.e.
http://www.mail-archive.com/linux-mmc@vger.kernel.org/msg16555.html ),
which, to me, still makes more sense (of course :).

Anyways, I'm not opposed either, so hopefully it works:

	Reviewed-by: Anton Vorontsov <cbouatmailru@gmail.com>

Thanks!
Anton.
