Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab1KJSd1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:33:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64970 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753694Ab1KJSdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:33:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6526"; a="134134652"
Date: Thu, 10 Nov 2011 10:33:21 -0800
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/8] MSM timer fixes and cleanups
Message-ID: <20111110183321.GA16832@huya.qualcomm.com>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 10:34:02AM -0800, Stephen Boyd wrote:
> Currently the MSM timers use the same physical counter
> for the clockevent and clocksource. This works as long
> as the clocksource isn't stopped from ticking during normal
> operation but unfortunately that isn't the case and the
> clocksource is stopped when the clockevent is shutdown.
> Even worse, switching the clocksource via sysfs at runtime will
> hang the system.
> 
> This series reorganizes the MSM timer code so that one counter
> is only used for either a clocksource or a clockevent, and not 
> both. In the process we reduce the lines of code and fix
> a few long-standing bugs.

How do you test these on the upstream kernel?  Booting successfully is
probably a good starting point, though.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
