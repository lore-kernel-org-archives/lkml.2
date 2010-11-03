Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab0KCNMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:12:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48040 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751616Ab0KCNM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:12:28 -0400
Date: Wed, 3 Nov 2010 09:12:34 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH] ASoC: Fix snd_soc_register_dais error handling
Message-ID: <20101103131233.GA16377@opensource.wolfsonmicro.com>
References: <1288767885.32421.5.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288767885.32421.5.camel@mola>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 03:04:45PM +0800, Axel Lin wrote:
> kzalloc for dai may fail at any iteration of the for loop,
> thus properly unregister already registered DAIs before return error.
> 
> The error handling code in snd_soc_register_dais() already ensure all the DAIs
> are unregistered before return error, we can remove the error handling code
> to unregister DAIs in snd_soc_register_codec().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.
