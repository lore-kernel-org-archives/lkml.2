Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1HRNTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 09:19:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51570 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996Ab1HRNTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 09:19:44 -0400
Message-ID: <4E4D115D.8090104@ti.com>
Date: Thu, 18 Aug 2011 14:19:25 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Johannes Stezenbach <js@sig21.net>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: sta32x: Move resource allocation and release to
 the corresponding callback functions
References: <1313652664.2917.3.camel@phoenix>
In-Reply-To: <1313652664.2917.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/08/11 08:31, Axel Lin wrote:
> This patch includes below small fixes:
> 
> 1. Move sta32x_set_bias_level() from sta32x_i2c_remove() to sta32x_remove().
> 2. Remove a redundant regulator_bulk_free() call in sta32x_i2c_remove(),
>    as we will call regulator_bulk_free() in sta32x_remove().
> 3. Remove unneeded snd_soc_codec_set_drvdata(codec, NULL) in sta32x_i2c_remove.
>    The i2c core will set the clientdata to NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Liam Girdwood <lrg@ti.com>
