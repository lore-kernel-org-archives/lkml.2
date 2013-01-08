Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3AHWcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:32:41 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:52360 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3AHWcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:32:39 -0500
Message-ID: <50EC9E84.9080904@wwwdotorg.org>
Date: Tue, 08 Jan 2013 15:32:36 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] pinctrl: nomadik: Add "ste,config" property etc
References: <1357643150-20250-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1357643150-20250-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 04:05 AM, Linus Walleij wrote:
> From: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> 
> The "ste,config" property will contain the pin config node.
> It will be easier to define a pin configuration and use it by
> reference without duplicating lines tedious.
> 
> Other cleanups to the initial DT patch. This will all be
> squashed into the original DT submission.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
