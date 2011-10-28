Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab1J1HQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:16:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47669 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab1J1HQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:16:19 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1319771527.3944.4.camel@phoenix>
References: <1319771281.3944.1.camel@phoenix> <1319771527.3944.4.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 28 Oct 2011 15:15:56 +0800
Message-ID: <CAF+7xWn+cEPCcxTwH=69WAyzkq=EZFhii7D3nQoB=OeKj=SV0A@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: wm8711: Add proper mask for wm8711_set_dai_fmt
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/28 Axel Lin <axel.lin@gmail.com>:
> Add mask for BIT[3:2] (the Input Audio Data Bit Length Select)
> of WM8711_IFACE(07h) register.
> Otherwise, BIT[3:2] will be always set to 0b00 here.
>
I think the subject line is not good.
I'll resend a patch with below subject line:
ASoC: Leave input audio data bit length settings untouched in wm8711_set_dai_fmt

Regards,
Axel
