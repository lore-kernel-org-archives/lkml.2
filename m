Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243Ab2ILQJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:09:20 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4275 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2ILQJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:09:18 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233494615"
Date: Wed, 12 Sep 2012 09:09:00 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 8/9] ARM: msm: Add DT support for 8960
Message-ID: <20120912160900.GB21878@codeaurora.org>
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
> +
> +	intc: interrupt-controller@02000000 {
> +		compatible = "qcom,msm-qgic2";
> +		interrupt-controller;
> +		#interrupt-cells = <3>;
> +		reg = < 0x02000000 0x1000 >,
> +		      < 0x02002000 0x1000 >;
> +	};

> +	timer@0200a004 {
	...
> +	timer@0200a024 {

Likewise here, the leading zeros need to be removed on the names.  I
can also take care of this one when I pull it in.

David


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
