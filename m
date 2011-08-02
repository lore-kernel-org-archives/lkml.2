Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1HBH5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:57:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35073 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752092Ab1HBH5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:57:37 -0400
Date: Tue, 2 Aug 2011 16:57:29 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps65023: Remove num_voltages array
Message-ID: <20110802075728.GA9553@opensource.wolfsonmicro.com>
References: <1312271310.12639.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312271310.12639.3.camel@phoenix>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 03:48:30PM +0800, Axel Lin wrote:

> @@ -519,12 +515,14 @@ static const struct tps_info tps65023_regs[] = {
>  		.name = "VDCDC2",
>  		.min_uV =  3300000,
>  		.max_uV = 3300000,
> +		.table_len = 0,
>  		.fixed = 1,
>  	},
>  	{
>  		.name = "VDCDC3",
>  		.min_uV =  1800000,
>  		.max_uV = 1800000,
> +		.table_len = 0,
>  		.fixed = 1,

No need to explicitly set things to zero, it's the default for things
declared static.  If this isn't declared static then it should be.
