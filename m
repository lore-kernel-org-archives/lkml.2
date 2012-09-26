Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab2IZQ5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:57:44 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35323 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab2IZQ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:57:43 -0400
Message-ID: <50633404.6030400@wwwdotorg.org>
Date: Wed, 26 Sep 2012 10:57:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: clarify idle vs sleep states
References: <1348664464-12079-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1348664464-12079-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2012 07:01 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This pure documentation fix tries to align the "idle" and
> "sleep" pin states to the idle and suspend states from
> runtime PM.

Seems reasonable,
Acked-by: Stephen Warren <swarren@nvidia.com>
