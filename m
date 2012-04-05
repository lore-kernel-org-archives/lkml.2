Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2DEPCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:02:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49382 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2DEPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 11:02:40 -0400
Message-ID: <4F7DB40D.20300@wwwdotorg.org>
Date: Thu, 05 Apr 2012 09:02:37 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] pinctrl: fix compile error if not select PINMUX support
References: <1333616843-3607-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1333616843-3607-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 03:07 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The pinctrl_register_mappings is defined in core.c, so change the dependent
> macro from CONFIG_MUX to CONFIG_PINCTRL.
> 
> The compile error message is:
> drivers/pinctrl/core.c:886: error: redefinition of 'pinctrl_register_mappings'
> include/linux/pinctrl/machine.h:160: note: previous definition of 'pinctrl_register_mappings' was here
> make[2]: *** [drivers/pinctrl/core.o] Error 1
> make[1]: *** [drivers/pinctrl] Error 2
> make: *** [drivers] Error 2
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
