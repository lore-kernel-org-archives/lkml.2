Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab0LCMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:25:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55518 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932292Ab0LCMZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:25:57 -0500
Date: Fri, 3 Dec 2010 12:25:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Fix inconsistent meaning of default case while
 checking alc5623->id
Message-ID: <20101203122554.GT859@rakim.wolfsonmicro.main>
References: <1291368357.20452.6.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291368357.20452.6.camel@mola>
X-Cookie: Shading within a garment may occur.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 05:25:57PM +0800, Axel Lin wrote:
> In alc5623_i2c_probe(),
> the default case for checking alc5623->id behaves the same as case 0x23.
> However, In alc5623_probe() the default case for checking alc5623->id
> becomes to be the same as case 0x21.
> This makes the meaning of default case inconsistent.

Applied, thanks.
