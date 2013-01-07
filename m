Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab3AGRKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:10:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44319 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3AGRKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:10:19 -0500
Message-ID: <50EB0178.9020601@wwwdotorg.org>
Date: Mon, 07 Jan 2013 10:10:16 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/2] pinctrl/nomadik: simplify GPIO probe
References: <1357568625-5979-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1357568625-5979-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 07:23 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Instead of jumping to a label later in the probe just return
> with an error code whenever probe() fails. Make sure to remove
> the gpiochip on irqdomain error now that we're at it.

The series,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

