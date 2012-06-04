Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760039Ab2FDKZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:25:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27915 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944Ab2FDKZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:25:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6731"; a="197376636"
Message-ID: <0b49042fd7b1b02788b29ccbe0b9b31a.squirrel@www.codeaurora.org>
In-Reply-To: <1338741260.1881.14.camel@joe2Laptop>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
    <1338741260.1881.14.camel@joe2Laptop>
Date: Mon, 4 Jun 2012 03:25:32 -0700 (PDT)
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Joe Perches" <joe@perches.com>
Cc: "Sagar Dharia" <sdharia@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, ohad@wizery.com, rusty@rustcorp.com.au,
        marc@plastictigers.com, rob@landley.net, joerg.roedel@amd.com,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-msm@vger.kernel.org, linus.walleij@linaro.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, trenn@suse.de, grant.likely@secretlab.ca,
        kheitke@codeaurora.org, ak@linux.intel.com, gclemson@audience.com,
        gregkh@linuxfoundation.org, linux-arm-kernel@lists.infradead.org
Reply-To: sdharia@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Reallocs should _always_ use a new temporary.
> Otherwise, there will be a memory leak of the
> original pointer memory on failure.
>
Thank you Joe for your comments. I will change the allocs, take care of
the styling based on your comments when I split the patch and resubmit.

Regards
Sagar

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

