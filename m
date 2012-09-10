Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab2IJRiR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:38:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43884 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2IJRiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:38:15 -0400
Message-ID: <504E2583.4070602@wwwdotorg.org>
Date: Mon, 10 Sep 2012 11:38:11 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl/nomadik : add MC1_a_2 pin MC1 function group
 list
References: <1347265874-3342-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1347265874-3342-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 02:31 AM, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@stericsson.com>
> 
> Another possible pin configuration for the MC1 pin group.

I have no objection to this, but I wonder if these will keep trickling
in. Is it a good idea to audit the whole driver and add everything
that's missing in one go?

