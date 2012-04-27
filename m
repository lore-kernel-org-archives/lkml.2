Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761048Ab2D0SQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:16:30 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45191 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761007Ab2D0SQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:16:29 -0400
Message-ID: <4F9AE27A.1020205@wwwdotorg.org>
Date: Fri, 27 Apr 2012 12:16:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Dong Aisheng <b29396@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linus.walleij@stericsson.com, s.hauer@pengutronix.de
Subject: Re: [PATCH 1/2] pinctrl: support gpio request deferred probing
References: <1335353894-22096-1-git-send-email-b29396@freescale.com>
In-Reply-To: <1335353894-22096-1-git-send-email-b29396@freescale.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 05:38 AM, Dong Aisheng wrote:
> From: Dong Aisheng <dong.aisheng@linaro.org>
> 
> As pinctrl handles, it may be possible the pinctrl gpio ranges
> are still not got registered when user call pinctrl_gpio_request.
> Thus, add defer support for it too.
> 
> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
