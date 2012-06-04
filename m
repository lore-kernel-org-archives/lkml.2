Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab2FDJy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:54:56 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2886 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab2FDJyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:54:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6731"; a="197370638"
Message-ID: <24d7d95d140259af6fd3c3074348b8fe.squirrel@www.codeaurora.org>
In-Reply-To: <20120530181340.GT9947@opensource.wolfsonmicro.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
    <20120530181340.GT9947@opensource.wolfsonmicro.com>
Date: Mon, 4 Jun 2012 02:54:54 -0700 (PDT)
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
From: "Sagar Dharia" <sdharia@codeaurora.org>
To: "Mark Brown" <broonie@opensource.wolfsonmicro.com>
Cc: "Sagar Dharia" <sdharia@codeaurora.org>, davidb@codeaurora.org,
        bryanh@codeaurora.org, kheitke@codeaurora.org, marc@plastictigers.com,
        gclemson@audience.com, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rob@landley.net,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, ohad@wizery.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
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

> This patch is about 150k which is rather large to review.  It would be
> enormously helpful for review if it could be broken down into a patch
> series.  For example, things like the device registration could be
> broken out into a separate patch as could the core bus operations and
> things like the clocking/bandwidth management.
>
Thank you Mark for looking at the patch.
It's a good idea to break the patch. I am on vacation right now till
6/15/12. I will work on breaking in logical pieces when I get back.

Regards
Sagar

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

