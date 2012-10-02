Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2JBRrZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:47:25 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11011 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab2JBRrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:47:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6853"; a="244702712"
Message-ID: <506B28AB.4060706@codeaurora.org>
Date: Tue, 02 Oct 2012 10:47:23 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Clear breakpoints before enabling
 monitor mode
References: <1348160260-19486-1-git-send-email-sboyd@codeaurora.org> <20120920173556.GQ4654@mudshark.cambridge.arm.com> <20120924171934.GE5522@mudshark.cambridge.arm.com> <506A3694.4070004@codeaurora.org> <20121002091301.GA8847@mudshark.cambridge.arm.com>
In-Reply-To: <20121002091301.GA8847@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/12 02:13, Will Deacon wrote:
>
> Thanks Stephen. I've also got some patches for OS save/restore of the debug
> registers using the various hardware locking and readout mechanisms, so that
> debug state can be persisted across low-power states.
>
> Do any of the Qualcomm chips (v7 as opposed to v7.1) implement the save/restore
> registers?

Yes, we have save and restore registers.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

