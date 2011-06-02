Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758866Ab1FBLxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:53:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56718 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755279Ab1FBLxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:53:51 -0400
Date: Thu, 2 Jun 2011 12:53:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd wm8350: allocate irq descs dynamically
Message-ID: <20110602115349.GF3085@opensource.wolfsonmicro.com>
References: <20110602114502.GO23771@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602114502.GO23771@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 01:45:02PM +0200, Sascha Hauer wrote:
> 
> This allows boards to leave the irq_base field unitialized and
> prevents them having to reserve irqs in the platform.
> pdata can be optional for irq support now. Without pdata the
> driver allocates some free irq range. With pdata and irq_base > 0
> the driver allocates exactly the specified irq.
> Without pdata the irq defaults to IRQF_TRIGGER_LOW.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
