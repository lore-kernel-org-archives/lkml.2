Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab1GJLMl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 07:12:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38500 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754474Ab1GJLMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 07:12:35 -0400
Date: Sun, 10 Jul 2011 20:10:51 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: tps65910: Fix a memory leak in tps65910_probe
 error path
Message-ID: <20110710111048.GB24191@opensource.wolfsonmicro.com>
References: <1310295127.4877.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310295127.4877.4.camel@phoenix>
X-Cookie: Never reveal your best argument.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 06:52:07PM +0800, Axel Lin wrote:
> Fix a memory leak if chip id is not matched.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
