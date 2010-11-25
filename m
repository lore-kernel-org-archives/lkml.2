Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab0KYVrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 16:47:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60917 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752721Ab0KYVrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 16:47:12 -0500
Date: Thu, 25 Nov 2010 21:47:20 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Charulatha <charu@ti.com>,
        Jarkko Nikula <jhnikula@gmail.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/2 RESEND] ASoC: Fix resource reclaim for osk5912
Message-ID: <20101125214718.GA26792@opensource.wolfsonmicro.com>
References: <1290608641.2235.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290608641.2235.5.camel@phoenix>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:24:01PM +0800, Axel Lin wrote:
> In current implementation, there are resources leak in the error path.
> This patch properly reclaims the allocated resources in the error path.
> 
> Also adds a missing clk_put in osk_soc_exit.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Jarkko Nikula <jhnikula@gmail.com>

Applied, thanks.
