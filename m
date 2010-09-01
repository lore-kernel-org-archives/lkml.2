Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0IAJPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:15:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60283 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751870Ab0IAJP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:15:27 -0400
Date: Wed, 1 Sep 2010 10:15:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] regulator: ad5398 - fix a memory leak
Message-ID: <20100901091544.GB17032@opensource.wolfsonmicro.com>
References: <1283308158.23075.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283308158.23075.1.camel@mola>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 10:29:18AM +0800, Axel Lin wrote:
> In current implementation, the address return from regulator_register()
> is different from the address for regulator_unregister().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
