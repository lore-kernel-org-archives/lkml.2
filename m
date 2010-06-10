Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab0FJLtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:49:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42556 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758786Ab0FJLtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:49:10 -0400
Date: Thu, 10 Jun 2010 12:49:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: sonic zhang <sonic.adi@gmail.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH] regulator: make sure the regulator is available prior
	to the consumers.
Message-ID: <20100610114907.GC17945@opensource.wolfsonmicro.com>
References: <1276160027.18479.1.camel@eight.analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276160027.18479.1.camel@eight.analog.com>
X-Cookie: Avoid gunfire in the bathroom tonight.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 04:53:47PM +0800, sonic zhang wrote:
> >From 5a71b38961b0889a239842defd733774ed3d9cdf Mon Sep 17 00:00:00 2001
> From: Sonic Zhang <sonic.zhang@analog.com>
> Date: Thu, 10 Jun 2010 16:50:20 +0800
> Subject: [PATCH] regulator: make sure the regulator is available prior to the consumers.
> 
> Some systems are likely to want this to be subsys_initcall() to
> make sure the regulator is available prior to the consumers.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
