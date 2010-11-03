Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab0KCXPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 19:15:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28604 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab0KCXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 19:15:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6156"; a="60539907"
Message-ID: <4CD1ECF7.5030105@codeaurora.org>
Date: Wed, 03 Nov 2010 16:15:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 1/3] ARM: Translate delay.S into (mostly) C
References: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>	 <1288300770-18350-2-git-send-email-sboyd@codeaurora.org> <1288808841.23615.5.camel@e102144-lin.cambridge.arm.com>
In-Reply-To: <1288808841.23615.5.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/03/2010 11:27 AM, Will Deacon wrote:
> Hi Stephen,
>
> On Thu, 2010-10-28 at 21:19 +0000, Stephen Boyd wrote:
>> Nico expressed concern that fixed lpj cmdlines will break due to
>> compiler optimizations. That doesn't seem to be the case since
>> before and after this patch I get the same lpj value when running
>> my CPU at 19.2 MHz. That should be sufficiently slow enough to
>> cover any machine running Linux.
>
> I appreciate this is an exceptional case, but there are some lucky
> guys at ARM who (as routinely as they can) boot Linux on sub 1MHz
> hardware. The delay loop is something they're keen to avoid so they do
> make use of the lpj= command line option and would rather it didn't
> break on them.

Do you know if it breaks at that frequency? I don't have any hardware to
test with that goes lower than the stated 19.2 MHz.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

