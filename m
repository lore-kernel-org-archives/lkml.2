Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab2EWU3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:29:45 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38381 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2EWU3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:29:44 -0400
Message-ID: <4FBD48B4.80806@wwwdotorg.org>
Date: Wed, 23 May 2012 14:29:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH RFC v3 1/3] pinctrl: remove pinctrl_remove_gpio_range
References: <1337779362-31259-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1337779362-31259-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 07:22 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> The gpio ranges will be automatically removed when the pinctrl
> driver is unregistered.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
