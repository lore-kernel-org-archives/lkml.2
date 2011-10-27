Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1J0IZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 04:25:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34633 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab1J0IZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 04:25:18 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111027071659.GB3053@opensource.wolfsonmicro.com>
References: <1319594021.2517.0.camel@phoenix> <1319594139.2517.2.camel@phoenix>
 <20111027071659.GB3053@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 27 Oct 2011 16:24:57 +0800
Message-ID: <CAF+7xW=5tUW4Tn6HZt4dC=OE_VipO+rMsa0v4+HSpsbUU+Ojxw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: wm8940: Fix mask for setting BCLKDIV
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Chris Paulson-Ellis <chris@edesix.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/27 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, Oct 26, 2011 at 09:55:39AM +0800, Axel Lin wrote:
>> According to the datasheet:
>> BCLK is controlled by BIT[4:2] of WM8940_CLOCK(06h) register.
>
> This doesn't apply against current code.
>
Ooops. sorry.
I generate the patch base on the for-3.3 branch of the asoc tree.
The commit bdb527e "ASoC: wm8940: Fix a typo for the mask of setting
WM8940_BCLKDIV"
in the for-3.3 branch should be dropped, because it is fixed by this commit now.

I'll send a v2 base on your for-next tree.

Thanks,
Axel
