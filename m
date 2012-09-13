Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab2IMEai (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 00:30:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50343 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754Ab2IMEah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 00:30:37 -0400
Date: Thu, 13 Sep 2012 12:30:30 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] sound/soc/soc-core.c: Remove useless kfree
Message-ID: <20120913043028.GD6732@opensource.wolfsonmicro.com>
References: <1347462407-13499-8-git-send-email-peter.senna@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347462407-13499-8-git-send-email-peter.senna@gmail.com>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 05:06:46PM +0200, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Remove useless kfree() and clean up code related to the removal.
> 
> The semantic patch that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)

Applied, thanks.
