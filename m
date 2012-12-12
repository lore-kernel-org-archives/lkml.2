Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab2LLW0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 17:26:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41807 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab2LLW0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 17:26:12 -0500
Message-ID: <50C90480.2010703@wwwdotorg.org>
Date: Wed, 12 Dec 2012 15:26:08 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 2/2 v2] pinctrl: skip deferral of hogs
References: <1355342027-2287-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1355342027-2287-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 12:53 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Up until now, as hogs were always taken at the end of the
> pin control device registration, it didn't cause any problem.
> But when starting to hog pins from the device core it will
> cause deferral of the pin controller device itself since the
> default pin fetch is done *before* the device probes, so
> let's fix this annoyance (which is also aesthetically ugly).
> 
> Also take some care to make sure that if any one map entry
> results in a deferral rather than a failure, then that
> deferral will take precedence.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
