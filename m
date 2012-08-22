Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab2HVR5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:57:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22047 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab2HVR5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:57:23 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6811"; a="225950918"
Message-ID: <50351D80.6010600@codeaurora.org>
Date: Wed, 22 Aug 2012 10:57:20 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
Subject: Re: [PATCH 1/4] ARM: export read_current_timer
References: <1345645780-2749-1-git-send-email-arnd@arndb.de> <1345645780-2749-2-git-send-email-arnd@arndb.de> <503513A2.1030002@codeaurora.org> <20120822174945.GS9093@mudshark.cambridge.arm.com>
In-Reply-To: <20120822174945.GS9093@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/12 10:49, Will Deacon wrote:
> On the topic of the timer stuff: Shinya/Stephen, did you have a chance to
> look at the registration stuff that was proposed? I'm happy to push it if
> people will actually use it.

Yes I have tested it on our internal trees and it looks good. I plan to
send a patch to move MSM's timers over to it later this week so that we
have at least two users upstream.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

