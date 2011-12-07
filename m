Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1LGPzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:55:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53910 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221Ab1LGPzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:55:47 -0500
Date: Wed, 7 Dec 2011 23:54:58 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, eric.miao@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] Regulator: Add Anatop regulator driver
Message-ID: <20111207155457.GB22355@opensource.wolfsonmicro.com>
References: <1323265998-29088-1-git-send-email-paul.liu@linaro.org>
 <1323265998-29088-2-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323265998-29088-2-git-send-email-paul.liu@linaro.org>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 09:53:18PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
> 
> Anatop regulator driver is used by i.MX6 SoC. This patch adds the
> Anatop regulator driver.

This changelog isn't terribly verbose but looking at the code what
you've actually got here is a driver that is simply an indirection
layer for the regulator API and no explanation as to why you're doing
this.  My first thought is that anything using this driver should just
be a regulator driver directly.
