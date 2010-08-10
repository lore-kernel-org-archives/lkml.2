Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab0HJOpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:45:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42538 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753107Ab0HJOpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:45:14 -0400
Date: Tue, 10 Aug 2010 15:45:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/4] mfd: wm831x-core - fix incorrect kfree(i2c) in
 i2c_driver probe callback handler
Message-ID: <20100810144511.GG6416@rakim.wolfsonmicro.main>
References: <1281336675.18804.6.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281336675.18804.6.camel@mola>
X-Cookie: Auction:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 02:51:15PM +0800, Axel Lin wrote:
> The i2c_client received in probe() should not be kfree()'d.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
