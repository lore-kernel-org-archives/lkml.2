Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422695Ab2EKThV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:37:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43301 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422662Ab2EKThQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:37:16 -0400
Message-ID: <4FAD6A69.7020303@wwwdotorg.org>
Date: Fri, 11 May 2012 13:37:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
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
Subject: Re: [PATCH 07/12 v2] pinctrl: add sleep state definition
References: <1336725143-25563-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1336725143-25563-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 02:32 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> There is an IDLE definition in the pinctrl framework, but for
> ux500 SLEEP is more apropriate.
> 
> I've added some comments on the semantics of the common states
> so as to avoid misunderstandings.
> 
> ChangeLog v1->v2:
> - Fixed terminology "on"->"into".
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

The updated patch 2/6/7 all look OK to me too now.
