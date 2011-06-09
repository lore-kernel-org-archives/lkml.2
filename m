Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab1FISRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:17:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52008 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab1FISRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:17:47 -0400
Message-ID: <4DF10E44.4030206@ti.com>
Date: Thu, 9 Jun 2011 19:17:40 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 1/3] regulator: Increase the limit on sysfs file names
References: <1307632942-667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1307632942-667-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/11 16:22, Mark Brown wrote:
> With verbose filenames we can easily hit 32 characters.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 

All Applied.

Thanks

Liam
