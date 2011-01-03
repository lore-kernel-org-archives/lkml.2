Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab1ACP7f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:59:35 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57306 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932069Ab1ACP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:59:35 -0500
Date: Mon, 3 Jan 2011 15:59:52 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yong Shen <yong.shen@linaro.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] regulator: Assign return value of mc13xxx_reg_rmw to
 ret
Message-ID: <20110103155951.GF6783@opensource.wolfsonmicro.com>
References: <1294070258.3320.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294070258.3320.4.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 11:57:38PM +0800, Axel Lin wrote:
> Otherwise, we will not return error if write to MC13892_SWITCHERS5 failed.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
