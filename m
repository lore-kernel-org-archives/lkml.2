Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934357Ab1JEKkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:40:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:48242 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933122Ab1JEKkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:40:19 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111005102122.GB9783@opensource.wolfsonmicro.com>
References: <1317809809.2374.5.camel@phoenix> <20111005102122.GB9783@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 5 Oct 2011 18:39:57 +0800
Message-ID: <CAF+7xW=Q_+Jq9j6X9XwB5jz5F6mxSOxKRwJBxmq9017qT0RyHg@mail.gmail.com>
Subject: Re: [RFC][PATCH] ASoC: Fix sync reg_cache with the hardware in wm8990_resume
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/5 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Oct 05, 2011 at 06:16:49PM +0800, Axel Lin wrote:
>> Current code has off-by-one bug of checking WM8990_RESET.
>> Besides, according to wm8990 datasheet (2-wire serial control mode):
>> A control word consists of 24 bits. The first 8 bits are address bits,
>> the remaining 16 bits are data bits.
>> Current code uses 7 bits address bits and 9 bits data bits which is incorrect.
>
> We should just convert drivers like this to snd_soc_cache_sync().

Yes. It would be better convert it to snd_soc_cache_sync().
Just think this patch may be useful for 3.1 or earlier kernel version.

Axel
