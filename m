Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252Ab1FWKfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 06:35:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48595 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759029Ab1FWKft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 06:35:49 -0400
Date: Thu, 23 Jun 2011 11:35:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] regulator/tps65912: storing error codes in u8
Message-ID: <20110623103547.GB21932@opensource.wolfsonmicro.com>
References: <20110623055715.GM14591@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623055715.GM14591@shale.localdomain>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 08:57:15AM +0300, Dan Carpenter wrote:
> get_ctrl_reg() returns -EINVAL so the error handling won't work here
> if reg is a u8.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
