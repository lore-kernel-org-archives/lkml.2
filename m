Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab1D0TKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:10:38 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43629 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab1D0TKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:10:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6329"; a="87985665"
Message-ID: <4DB86A2D.3030406@codeaurora.org>
Date: Wed, 27 Apr 2011 12:10:37 -0700
From: Michael Bohan <mbohan@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/6] x86: Allow the user not to build hw_breakpoints
References: <1303923602-2923-1-git-send-email-fweisbec@gmail.com> <1303923602-2923-4-git-send-email-fweisbec@gmail.com> <4DB854AA.6070101@zytor.com> <20110427182633.GB1753@nowhere>
In-Reply-To: <20110427182633.GB1753@nowhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/27/2011 11:26 AM, Frederic Weisbecker wrote:
> On Wed, Apr 27, 2011 at 10:38:50AM -0700, H. Peter Anvin wrote:
>>
>> How big of a win, if any, is this, really?
>
> That's pretty significant, because if you can disable breakpoints,
> then you can disable perf. Together they make quite a chunk.

Another advantage is the ability to disable these features for kernel 
bringup on new targets and kernel versions. Recently in v2.6.38 
hw_breakpoints were broken in ARM. A change like this would have saved 
me a hack to the Kconfig at the least.

Mike

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
