Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab1CITgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:36:44 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37180 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab1CITgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:36:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="78793537"
Message-ID: <4D77D6CB.402@codeaurora.org>
Date: Wed, 09 Mar 2011 11:36:43 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: hw_breakpoint: Fix newlines in WARNings
References: <1298633466.32588.1.camel@e102144-lin.cambridge.arm.com> <1298693163-18269-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1298693163-18269-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On 02/25/2011 08:06 PM, Stephen Boyd wrote:
> Will Deacon wrote:
>>> I'd prefer the message text not to be line wrapped, even if it
>>> violates the general line length rule, because that makes it easier to
>>> grep for the message in the source code.
>> Ok, that's understandable. Moving the text onto its own line will limit
>> the damage to the line length too. Stephen - are you happy to make these
>> changes as part of your previous patch?
>

Do you want to take this? I'm going to submit it to the patch tracker
tomorrow otherwise.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

