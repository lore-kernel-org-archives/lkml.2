Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab0HTJhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:37:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57536 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752959Ab0HTJhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:37:04 -0400
Date: Fri, 20 Aug 2010 10:37:01 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ian Molton <ian@mnementh.co.uk>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH] ASoC: e740_wm9705 - free gpio in e740_exit()
Message-ID: <20100820093701.GA13668@rakim.wolfsonmicro.main>
References: <1282200025.9347.1.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282200025.9347.1.camel@mola>
X-Cookie: No guts, no glory.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 02:40:25PM +0800, Axel Lin wrote:
> In e740_init(), we call gpio_request() for
> GPIO_E740_MIC_ON, GPIO_E740_AMP_ON and GPIO_E740_WM9705_nAVDD2.
> We should free the these gpio accordingly in e740_exit().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
