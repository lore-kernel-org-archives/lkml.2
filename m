Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab2DLS1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 14:27:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35866 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab2DLS1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 14:27:12 -0400
Message-ID: <4F871E7D.5020404@wwwdotorg.org>
Date: Thu, 12 Apr 2012 12:27:09 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: mark non-EXPERIMENTAL
References: <1334253104-30527-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1334253104-30527-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 11:51 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> With the finalization of the external driver API and the device
> tree support, this subsystem is now mature and can be promoted to
> non-experimental status.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Stephen Warren <swarren@wwwdotorg.org>

It certainly works great for me:-)
