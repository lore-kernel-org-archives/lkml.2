Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0FRT0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 15:26:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42897 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab0FRT0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 15:26:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6017"; a="44714977"
Subject: Re: [PATCH 0/3] msm: Add gpiolib devices to MSM7x30 and QSD8x50.
From: Daniel Walker <dwalker@codeaurora.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 12:26:04 -0700
Message-ID: <1276889164.30433.54.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 12:12 -0700, Gregory Bean wrote:
> Hi folks:
> 
> Here is a proposed patch series which adds the configuration and devices
> needed to enable gpiolib on the MSM7x30 and QSD8x50 chipsets.
> 
> Patch 1 adds the register mapping information for all supported
> MSM/QSD targets.  I wasn't sure about adding register definitions for boards
> which weren't yet using those definitions, but the alternative was to have
> each following patch change gpio_hw.h over and over, so I put all the
> definitions in at once.  Thoughts?
> 
> Patch 2 adds the first target, the 7x30, as well as some generic macros
> to ease the definition of the gpio devices and their platform data,
> as this is long-winded, but mindless and repetitive work.  I considered
> putting the generic macro-definitions in their own patch, but without
> any targets to use them it seemed a little silly to leave them on their
> own and I ended up attaching them to the first patch to use them - 
> what do y'all think?  Does it warrant being split up?
> 
> Patch 3 adds device configuration for the 8x50.

Does it bisect?

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

