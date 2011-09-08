Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab1IHFvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 01:51:10 -0400
Received: from bitmer.com ([213.157.87.50]:37074 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab1IHFvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 01:51:09 -0400
Message-ID: <4E6857BF.9010904@bitmer.com>
Date: Thu, 08 Sep 2011 08:50:55 +0300
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Mans Rullgard <mans.rullgard@linaro.org>, alsa-devel@alsa-project.org,
        linaro-dev@lists.linaro.org, Takashi Iwai <tiwai@suse.de>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH v2] ASoC: omap: add MODULE_ALIAS to mcbsp
 and pcm drivers
References: <1315393641-21261-1-git-send-email-mans.rullgard@linaro.org> <20110907171049.GA2906@opensource.wolfsonmicro.com>
In-Reply-To: <20110907171049.GA2906@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 08:10 PM, Mark Brown wrote:
> On Wed, Sep 07, 2011 at 12:07:21PM +0100, Mans Rullgard wrote:
>> This adds MODULE_ALIAS directives to the omap-mcbsp-dai and
>> omap-pcm-audio drivers so they can be auto-loaded when platform
>> devices are scanned.
>
> Acked-by: Mark Brown<broonie@opensource.wolfsonmicro.com>

Now looks good.

Acked-by: Jarkko Nikula <jarkko.nikula@bitmer.com>
