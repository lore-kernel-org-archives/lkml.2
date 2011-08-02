Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1HBGBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 02:01:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54816 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750773Ab1HBGBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 02:01:46 -0400
Date: Tue, 2 Aug 2011 15:01:31 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Haojian Zhuang <haojian.zhuang@marvell.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Ensure enough enable time for max8649
Message-ID: <20110802060128.GA7925@opensource.wolfsonmicro.com>
References: <1312260896.6161.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312260896.6161.1.camel@phoenix>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 12:54:56PM +0800, Axel Lin wrote:
> Integer division may truncate the result, thus max8649_enable_time() may return
> slightly shorter enable time. This patch fixes it.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
