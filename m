Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1AXWNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 17:13:11 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55044 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1AXWNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 17:13:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71597623"
From: David Brown <davidb@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 07/11] msm: Add MSM 8960 cpu_is check
In-Reply-To: <1295904928.29639.58.camel@c-dwalke-linux.qualcomm.com> (Daniel
	Walker's message of "Mon, 24 Jan 2011 13:35:28 -0800")
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
	<1295468747-22796-1-git-send-email-davidb@codeaurora.org>
	<1295468747-22796-8-git-send-email-davidb@codeaurora.org>
	<1295901976.29639.53.camel@c-dwalke-linux.qualcomm.com>
	<8yak4hukn00.fsf@huya.qualcomm.com>
	<1295904928.29639.58.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110124:linux-arm-msm@vger.kernel.org::hACfkPeW5GSqTn63:000000000000000000000000000000000GdH
X-Hashcash: 1:20:110124:linux-arm-kernel@lists.infradead.org::s50pmklHnblnp1eW:00000000000000000000000001kfi
X-Hashcash: 1:20:110124:dwalker@codeaurora.org::E5n/yJ5GHH6dhGQc:0000000000000000000000000000000000000004dIm
X-Hashcash: 1:20:110124:linux-kernel@vger.kernel.org::QAWGO5DP+euJsdCW:000000000000000000000000000000000DDYn
Date: Mon, 24 Jan 2011 14:13:07 -0800
Message-ID: <8ya8vyakl1o.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24 2011, Daniel Walker wrote:

>> What do you want me to call it?
>> 
>>   #define cpu_is_97d0c886-3768-4998-8925-16f36209d0d1()
>
> I want you to call it msm8x60 ..

msm8960 is not a subset of msm8x60.  It's just a misleading name.  It's
a very different device, and needs it's own identifier.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
