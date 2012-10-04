Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab2JDLZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:25:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47156 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109Ab2JDLZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:25:52 -0400
Date: Thu, 4 Oct 2012 12:25:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: sameo@linux.intel.com, ashish.jangam@kpitcummins.com, dchen@diasemi.com,
        arnd@arndb.de, kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH 2/6] mfd: da9052: Introduce da9052-irq.c
Message-ID: <20121004112546.GK4360@opensource.wolfsonmicro.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
 <1349320509-26930-2-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349320509-26930-2-git-send-email-festevam@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 12:15:05AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Create a da9052-irq.c file so that it can handle interrupt related functions.
> 
> This is useful for allowing the da9052 drivers to use such functions
> when dealing with da9052 interrupts.

Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
