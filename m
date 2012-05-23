Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707Ab2EWRsH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:48:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23149 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671Ab2EWRsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:48:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6720"; a="193971489"
Date: Wed, 23 May 2012 10:48:03 -0700
From: David Brown <davidb@codeaurora.org>
To: Rajendra Nayak <rnayak@ti.com>
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        robherring2@gmail.com, linaro-dev@lists.linaro.org, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/4] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20120523174803.GA18609@codeaurora.org>
References: <1321615040-13257-1-git-send-email-rnayak@ti.com>
 <1321615040-13257-2-git-send-email-rnayak@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321615040-13257-2-git-send-email-rnayak@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 04:47:17PM +0530, Rajendra Nayak wrote:

> +	xyzreg: regulator@0 {
> +		regulator-min-microvolt = <1000000>;
> +		regulator-max-microvolt = <2500000>;
> +		regulator-always-on;
> +		vin-supply = <&vin>;
> +	};

Just noticed this, but the '@0' shouldn't be on the name, since there
isn't a reg attribute on this node.  Perhaps it should be
"regulator-xyz"?

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
