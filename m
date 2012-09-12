Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab2ILQHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:07:18 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:3444 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab2ILQHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:07:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233493648"
Date: Wed, 12 Sep 2012 09:07:10 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bryan Huntsman <bryanh@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/9] ARM: msm: Add DT support to msm_timer
Message-ID: <20120912160710.GA21878@codeaurora.org>
References: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
 <1346873339-10927-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346873339-10927-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 12:28:53PM -0700, Stephen Boyd wrote:

> diff --git a/Documentation/devicetree/bindings/arm/msm/timer.txt b/Documentation/devicetree/bindings/arm/msm/timer.txt

> +       timer@0200a004 {
> +               compatible = "qcom,msm-gpt", "qcom,msm-timer";
> +               interrupts = <1 2 0x301>;
> +               reg = <0x0200a004 0x10>;
> +               clock-frequency = <32768>;
> +               cpu-offset = <0x40000>;
> +       };
> +
> +       timer@0200a024 {
> +               compatible = "qcom,msm-dgt", "qcom,msm-timer";
> +               interrupts = <1 3 0x301>;
> +               reg = <0x0200a024 0x10>,
> +                     <0x0200a034 0x4>;
> +               clock-frequency = <6750000>;
> +               cpu-offset = <0x40000>;
> +       };

The names should be timer@200a004 and timer@200a024, without the
leading zero.  If there are no other concerns, I can just fix these up
when I pull the patch in.  No need to resend.

Thanks,
David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
