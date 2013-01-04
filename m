Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3ADUED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:04:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:58909 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab3ADUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:04:01 -0500
Message-ID: <50E735AD.4060008@wwwdotorg.org>
Date: Fri, 04 Jan 2013 13:03:57 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>
Subject: Re: [PATCH] pinctrl: add pinconf-generic defines for output
References: <1357318849-12616-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1357318849-12616-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2013 10:00 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This adds a definition of a generic output configuration
> for a certain pin when using the generic pin configuration
> library. Whereas driving pins low/high is usually a GPIO
> business, you may want to set up pins into a default state
> using hogs, and never touch them again. This helps out
> with that scenario.

Seems plausible:-) Although I wonder if this is moving towards DT
content setting up HW rather than writing drivers for things. Probably
not an issue so far though.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
