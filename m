Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0KSLZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:25:49 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53872 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752843Ab0KSLZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:25:48 -0500
Date: Fri, 19 Nov 2010 11:25:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Steve Sakoman <steve@sakoman.com>
Subject: Re: [PATCH] ASoC: Move kfree(twl4030) to twl4030_soc_remove()
Message-ID: <20101119112546.GI7233@rakim.wolfsonmicro.main>
References: <1290159068.10001.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290159068.10001.5.camel@mola>
X-Cookie: Pass with care.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 05:31:08PM +0800, Axel Lin wrote:
> As we allocate memory for twl4030 in twl4030_codec_probe(),
> twl4030_codec_remove() is a better place to free the memory.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
