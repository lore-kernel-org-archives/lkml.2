Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0HJOph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:45:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42540 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757805Ab0HJOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:45:26 -0400
Date: Tue, 10 Aug 2010 15:45:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 4/4] mfd: wm8994-core - fix incorrect kfree(i2c) in
 i2c_driver probe callback handler
Message-ID: <20100810144525.GH6416@rakim.wolfsonmicro.main>
References: <1281336736.18804.7.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281336736.18804.7.camel@mola>
X-Cookie: Auction:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 02:52:16PM +0800, Axel Lin wrote:
> The i2c_client received in probe() should not be kfree()'d.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
