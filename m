Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab1EYJsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 05:48:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53359 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1EYJsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 05:48:06 -0400
Message-ID: <4DDCD051.6020607@ti.com>
Date: Wed, 25 May 2011 10:48:01 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator: Use _cansleep() for WM8994 regulator GPIOs
References: <1306250080-8165-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1306250080-8165-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/11 16:14, Mark Brown wrote:
> The WM8994 regulator driver is perfectly happy if the GPIO used to enable
> the regulator sleeps so call the appropriate GPIO API.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/wm8994-regulator.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 

Applied.

Thanks

Liam
