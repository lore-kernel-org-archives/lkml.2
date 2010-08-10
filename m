Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab0HJOqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 10:46:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42543 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757686Ab0HJOqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 10:46:09 -0400
Date: Tue, 10 Aug 2010 15:46:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: Re: [PATCH RESEND] regulator: tps6507x - add missing
 platform_set_drvdata in tps6507x_pmic_probe
Message-ID: <20100810144608.GI6416@rakim.wolfsonmicro.main>
References: <1281340283.20518.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281340283.20518.1.camel@mola>
X-Cookie: Auction:
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 03:51:23PM +0800, Axel Lin wrote:
> We should call platform_set_drvdata() before calling platform_get_drvdata().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
