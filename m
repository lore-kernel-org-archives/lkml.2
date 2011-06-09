Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab1FIN6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 09:58:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58913 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758164Ab1FIN6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 09:58:14 -0400
Message-ID: <4DF0D129.8030301@ti.com>
Date: Thu, 9 Jun 2011 14:56:57 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] ASoC: snd_soc_new_{mixer,mux,pga} make sure to use right
 DAPM context
References: <1307618556-32068-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1307618556-32068-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/11 12:22, Lars-Peter Clausen wrote:
> Currently it is possible that snd_soc_new_{mixer,mux,pga} is called with a
> DAPM context not matching the widgets context. This can lead to a wrong
> prefix_len calculation, which will result in undefined behaviour. To avoid
> this always use the DAPM context from the widget itself.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: stable@kernel.org
> 

Acked-by: Liam Girdwood <lrg@ti.com>
