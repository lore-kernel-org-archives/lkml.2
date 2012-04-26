Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2DZPWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:22:34 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32795 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404Ab2DZPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:22:33 -0400
Message-ID: <4F996837.1010202@wwwdotorg.org>
Date: Thu, 26 Apr 2012 09:22:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: John Crispin <blogic@openwrt.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: enhance reporting of errors when loading from
 DT
References: <1335451631-17826-1-git-send-email-blogic@openwrt.org>
In-Reply-To: <1335451631-17826-1-git-send-email-blogic@openwrt.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 08:47 AM, John Crispin wrote:
> There are a few places in the api where the code simply returns -EINVAL when
> it finds an error. An example is pinmux_map_to_setting() which now reports an
> error if we try to match a group with a function that it does not support.
> 
> The reporting of errors in pinconf_check_ops and pinmux_check_ops now has the
> same style and is located inside the according functions and not the calling
> code.
> 
> When the map is found in the DT but the default state can not be selected we
> get an error to know that the code at least tried.
> 
> The patch also removes a stray word from one comment and a "->" from another
> for the sake of consistency.
> 
> Finally we replace a few pr_err/debug() calls with dev_err/dbg().
> 
> Thanks go to Stephen Warren for reviewing the patch and enhancing the reporting
> inside pinmux_map_to_setting().

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
