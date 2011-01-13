Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab1AMOQV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:16:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48547 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756794Ab1AMOQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:16:19 -0500
Date: Thu, 13 Jan 2011 14:16:35 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: alsa-devel@alsa-project.org, uclinux-dist-devel@blackfin.uclinux.org,
        stable@kernel.org, stable-review@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Blackfin TDM: fix missed snd_soc_dai_get_drvdata
 update
Message-ID: <20110113141634.GH11840@opensource.wolfsonmicro.com>
References: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294805299-5265-1-git-send-email-vapier@gentoo.org>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 11:08:19PM -0500, Mike Frysinger wrote:
> One spot was missed in this driver when converting from
> snd_soc_dai.private_data to snd_soc_dai_get_drvdata.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, thanks.
