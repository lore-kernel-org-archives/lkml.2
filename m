Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1L2R7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 12:59:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40505 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754746Ab1L2R7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 12:59:11 -0500
Date: Thu, 29 Dec 2011 17:59:05 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 1/2] regulator: mc13783: Convert to devm_kzalloc()
Message-ID: <20111229175904.GG2909@opensource.wolfsonmicro.com>
References: <1325174163-27955-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325174163-27955-1-git-send-email-festevam@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 01:56:02PM -0200, Fabio Estevam wrote:
> Convert mc13783-regulator driver to use devm_kzalloc().
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied, thanks.
