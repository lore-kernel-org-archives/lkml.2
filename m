Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1HLIeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 04:34:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39234 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751968Ab1HLIen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 04:34:43 -0400
Date: Fri, 12 Aug 2011 17:34:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, Jonas Aberg <jonas.aberg@stericsson.com>,
        Philippe Langlais <philippe.langlais@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 22/23] regulator/dbx500-prcmu: factor out common code
Message-ID: <20110812083425.GA13557@opensource.wolfsonmicro.com>
References: <1313137833-31314-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313137833-31314-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 10:30:33AM +0200, Linus Walleij wrote:
> From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> 
> Before we add the DB5500 PRCMU voltage domain regulator, let's
> factor out the pieces of code that are common between both
> drivers.

Acked-by: Mark Brown <broonie@opensouirce.wolfsonmicro.com>
