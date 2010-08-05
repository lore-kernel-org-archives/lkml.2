Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760262Ab0HEMMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:12:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39429 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755476Ab0HEMMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:12:05 -0400
Date: Thu, 5 Aug 2010 13:12:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] lp3971: remove redundant checking for count in
 lp3971_i2c_read()
Message-ID: <20100805121203.GE13146@rakim.wolfsonmicro.main>
References: <1280979773.1238.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280979773.1238.4.camel@mola>
X-Cookie: Type louder, please.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 11:42:53AM +0800, Axel Lin wrote:
> We already check count value before calling i2c_smbus_read_byte_data(),
> no need to check it again.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
