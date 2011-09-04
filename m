Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1IDOsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 10:48:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58071 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab1IDOsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 10:48:30 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20110904141015.GB3668@opensource.wolfsonmicro.com>
References: <1315140751.8673.1.camel@phoenix> <20110904141015.GB3668@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Sun, 4 Sep 2011 22:48:09 +0800
Message-ID: <CAF+7xWn=1M+iGuXVt6cA0j+b4wZNJh+iyE7ChTQf2xaKCqbaMw@mail.gmail.com>
Subject: Re: [PATCH] ASoC: codecs: Remove unused mutex
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/4 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Sun, Sep 04, 2011 at 08:52:31PM +0800, Axel Lin wrote:
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
>> Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> ---
>>  sound/soc/codecs/alc5623.c |    2 --
>>  sound/soc/codecs/wm9090.c  |    2 --
>
> This has already been done for wm9090, can you resubmit with just the
> alc5623 change please?
>
Ok. A new patch "ASoC: alc5623: Remove unused mutex" is on the way.

Thanks,
Axel
