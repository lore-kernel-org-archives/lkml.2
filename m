Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab1AZWBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 17:01:45 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6109 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1AZWBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 17:01:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="71883694"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] msm: clock: Remove unused code and definitions
In-Reply-To: <1295992937.25496.75.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Tue, 25 Jan 2011 14:02:17 -0800")
References: <1295927118-27591-1-git-send-email-sboyd@codeaurora.org>
	<1295927118-27591-2-git-send-email-sboyd@codeaurora.org>
	<1295991537.25496.49.camel@c-dwalke-linux.qualcomm.com>
	<4D3F4609.3000808@codeaurora.org>
	<1295992937.25496.75.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110126:sboyd@codeaurora.org::ZtTkV4mRh3ZwE9+o:000000000000000000000000000000000000000001Nge
X-Hashcash: 1:20:110126:linux-arm-msm@vger.kernel.org::9ZXjWm4I9G35NZhw:000000000000000000000000000000000/wj
X-Hashcash: 1:20:110126:skannan@codeaurora.org::tVT8Unnj0CYAFteb:0000000000000000000000000000000000000000wkd
X-Hashcash: 1:20:110126:linux-arm-kernel@lists.infradead.org::rQbD9ALwKAW7P6ts:00000000000000000000000003cHc
X-Hashcash: 1:20:110126:linux-kernel@vger.kernel.org::ce/J72ouzFuSHpT7:0000000000000000000000000000000004wjO
X-Hashcash: 1:20:110126:dwalker@codeaurora.org::pb/1Wej3MKipa49m:0000000000000000000000000000000000000006TD2
Date: Wed, 26 Jan 2011 14:01:37 -0800
Message-ID: <8ya1v3z8gu6.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25 2011, Daniel Walker wrote:

> On Tue, 2011-01-25 at 13:52 -0800, Saravana Kannan wrote:
>> On 01/25/2011 01:38 PM, Daniel Walker wrote:
>> > On Mon, 2011-01-24 at 19:45 -0800, Stephen Boyd wrote:
>> >> Remove dead code and push out clock-7x30.h and clock-pcom.h to
>> >> where they are actually used.
>> >>
>> >
>> > I'd do two patches for this. The stuff your doing is too disconnected.
>> >
>> > Daniel
>> >
>> There is a whole bunch of unused code in the clock files and it's being 
>> deleted. I don't see a point of splitting it up per file.
>
> It's easier to review when changes aren't merged that don't related to
> each other.

In this particular case, the patch is a bunch of removal of dead code,
and kind of makes sense to keep it together.  I'm fine with it as is.

David Brown

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
