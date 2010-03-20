Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab0CTRXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:23:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35284 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752036Ab0CTRXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:23:16 -0400
Date: Sat, 20 Mar 2010 17:23:15 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 17/24] regulator: fix dangling pointers
Message-ID: <20100320172315.GE1549@opensource.wolfsonmicro.com>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-18-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269094385-16114-18-git-send-email-w.sang@pengutronix.de>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 03:12:58PM +0100, Wolfram Sang wrote:
> Fix I2C-drivers which missed setting clientdata to NULL before freeing the
> structure it points to. Also fix drivers which do this _after_ the structure
> was freed already.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but like I say this doesn't seem like something that belongs in the
drivers.
