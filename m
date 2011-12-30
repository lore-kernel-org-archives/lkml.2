Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1L3CH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 21:07:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58391 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754604Ab1L3CHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 21:07:25 -0500
Date: Fri, 30 Dec 2011 02:07:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 2/2] regulator: mc13892: Convert to devm_kzalloc()
Message-ID: <20111230020712.GF9737@opensource.wolfsonmicro.com>
References: <1325174163-27955-2-git-send-email-festevam@gmail.com>
 <1325196300-3930-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325196300-3930-1-git-send-email-festevam@gmail.com>
X-Cookie: So this is it.  We're going to die.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 08:05:00PM -0200, Fabio Estevam wrote:
> Convert mc13892-regulator driver to use devm_kzalloc().
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied, thanks.
