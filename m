Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab2BVGih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:38:37 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:24836
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751716Ab2BVGif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:38:35 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 22 Feb 2012 14:46:19 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@stericsson.com>, <B29396@freescale.com>,
        <s.hauer@pengutronix.de>, <dongas86@gmail.com>, <shawn.guo@linaro.org>,
        <thomas.abraham@linaro.org>, <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/20] pinctrl: Disallow map table entries with NULL
 dev_name field
Message-ID: <20120222064618.GC11087@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-10-git-send-email-swarren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1329720360-23227-10-git-send-email-swarren@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:45:49PM -0700, Stephen Warren wrote:
> Hog entries are mapping table entries with .ctrl_dev_name == .dev_name.
> All other mapping table entries need .dev_name set so that they will
> match some pinctrl_get() call. All extant PIN_MAP*() macros set
> .dev_name.
> 
> So, there is no reason to allow mapping table entries without .dev_name
> set. Update the code and documentation to disallow this.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---

Except code derived from last patch that not allow the map name to be NULL
for pinctrl_get since it seems still not determined, for this patch itself:

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

