Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933606Ab2EWOxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:53:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35487 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932304Ab2EWOxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:53:39 -0400
Message-ID: <4FBCF9F0.1010901@wwwdotorg.org>
Date: Wed, 23 May 2012 08:53:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: add a pinctrl_mux_group_selected() function
References: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1205230020210.11851@axis700.grange>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 04:23 PM, Guennadi Liakhovetski wrote:
> This patch adds a new function to allow clients to verify, whether a
> certain group is selected in the currently active setting or not.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> Maybe there is already a way to do this without adding a new function, I 
> haven't found one, hence this patch.

This function doesn't currently exist because it breaks the pinctrl
conceptual model, which is that devices ask pinctrl for certain settings
whenever they need them, rather than information flowing the other way.

What's the use case for this new functionality?
