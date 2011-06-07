Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352Ab1FGIeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 04:34:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36855 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab1FGIeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 04:34:09 -0400
Message-ID: <4DEDE269.7090404@ti.com>
Date: Tue, 7 Jun 2011 09:33:45 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] ASoC: Blackfin: bf5xx-ad1836: Fix codec device name
References: <1307435086-29877-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1307435086-29877-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/11 09:24, Lars-Peter Clausen wrote:
> Fix the codec_name field of the dai_link to match the actual device name
> of the codec. Otherwise the card won't be instantiated.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Acked-by: Liam Girdwood <lrg@ti.com>
