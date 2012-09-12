Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760410Ab2ILQXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:23:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52686 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760383Ab2ILQXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:23:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233502553"
Date: Wed, 12 Sep 2012 09:23:41 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 8/9] ARM: msm: Add DT support for 8960
Message-ID: <20120912162341.GA22065@codeaurora.org>
References: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
 <1346873339-10927-9-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346873339-10927-9-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:28:58PM -0700, Stephen Boyd wrote:

> diff --git a/arch/arm/boot/dts/msm8960-cdp.dts b/arch/arm/boot/dts/msm8960-cdp.dts

> +	intc: interrupt-controller@02000000 {
> +	timer@0200a004 {
> +	timer@0200a024 {

Same here.  Again, I'll fix these when I pull the patch in.

I guess a question: According to
https://lists.ozlabs.org/pipermail/devicetree-discuss/2012-February/012412.html

these leading zeros shouldn't be there, but I do find a few hundred of
them in our existing devicetree files.  There are also a handful that
have a @0xnnn form of address.

David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
