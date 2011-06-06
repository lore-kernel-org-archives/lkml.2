Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1FFTkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:40:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37378 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab1FFTkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:40:15 -0400
Message-ID: <4DED2D08.90201@ti.com>
Date: Mon, 6 Jun 2011 20:39:52 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] ASoC: AD1836: Fix setting the PCM format
References: <1307360320-4727-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1307360320-4727-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/11 12:38, Lars-Peter Clausen wrote:
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
> ---
> This patch doesn't need to go into stable since there are currently no users of
> PCM formats other than S32, which is the default.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

All

Acked-by: Liam Girdwood <lrg@ti.com>
