Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab1EZLEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:04:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58473 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab1EZLEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:04:14 -0400
Message-ID: <4DDE33A8.3090609@ti.com>
Date: Thu, 26 May 2011 12:04:08 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: wm1250-ev1: Define "WM1250 Output" with SND_SOC_DAPM_OUTPUT
References: <1306378452.10398.9.camel@phoenix>
In-Reply-To: <1306378452.10398.9.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/05/11 03:54, Axel Lin wrote:
> Codec output pin should be defined with SND_SOC_DAPM_OUTPUT.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Note: 
> Just found this bug while reading the code.
> I don't have this hardware handy. I appreciate if someone can test it.
> 
> Axel
> 

The fix does look correct.

Acked-by: Liam Girdwood <lrg@ti.com>

