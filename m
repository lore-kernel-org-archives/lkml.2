Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1FGItO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:49:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56832 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751834Ab1FGItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:49:12 -0400
Date: Tue, 7 Jun 2011 09:49:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] ASoC: AD1836: Fix build error
Message-ID: <20110607084910.GB18544@opensource.wolfsonmicro.com>
References: <20110607115505.71c9a330.sfr@canb.auug.org.au>
 <1307422979-14160-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307422979-14160-1-git-send-email-lars@metafoo.de>
X-Cookie: Avoid reality at all costs.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 07:02:59AM +0200, Lars-Peter Clausen wrote:
> Commit f97d0c6d5f94 ("ASoC: AD1836: Add input gain control for ADC2") contained
> a typo in the register name, causing a build error. This patch fixes it.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

Applied, thanks.
