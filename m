Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab0IBQuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 12:50:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38832 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018Ab0IBQuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 12:50:00 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6093"; a="53034963"
Subject: Re: [PATCH 14/24] msm: add hotplug stub functions
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
In-Reply-To: <20100902111157.GX26319@n2100.arm.linux.org.uk>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
	 <1282712273-344-15-git-send-email-johlstei@codeaurora.org>
	 <20100902111157.GX26319@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 09:49:37 -0700
Message-ID: <1283446177.3674.0.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-02 at 12:11 +0100, Russell King - ARM Linux wrote:
> On Tue, Aug 24, 2010 at 09:57:43PM -0700, Jeff Ohlstein wrote:
> > From: Daniel Walker <dwalker@codeaurora.org>
> > 
> > We don't actually do anything for hotplug yet. This just lets
> > everything compile, even when hotplug is enabled.
> 
> And the point of that is?  If you're not supporting hotplug CPU yet, then
> don't allow it to be enabled.

How do we do that? I didn't see a easy way to prevent it.

Daniel


-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

