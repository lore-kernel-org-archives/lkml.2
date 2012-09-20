Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652Ab2ITJg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 05:36:58 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:33728 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2ITJg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 05:36:56 -0400
X-AuditID: b753bd60-91b5cba000007c38-e8-505ae3b60f26
X-AuditID: b753bd60-91b5cba000007c38-e8-505ae3b60f26
Message-ID: <505AE3B5.6080401@hitachi.com>
Date: Thu, 20 Sep 2012 18:36:53 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, X86-ML <x86@kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] x86, kprobes: Hide skip_singlestep forward declaration
 properly
References: <1348062414-6578-1-git-send-email-bp@amd64.org> <505ADB6B.3070706@hitachi.com> <20120920092540.GB3611@gmail.com>
In-Reply-To: <20120920092540.GB3611@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/09/20 18:25), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2012/09/19 22:46), Borislav Petkov wrote:
>>> From: Borislav Petkov <borislav.petkov@amd.com>
>>>
>>> I get
>>>
>>> arch/x86/kernel/kprobes.c:544:23: warning: ‘skip_singlestep’ declared ‘static’ but never defined [-Wunused-function]
>>>
>>> on tip/auto-latest.
>>>
>>> Hide the forward declaration in the KPROBES_CAN_USE_FTRACE as it
>>> is done in its callsites.
>>
>> Thank you for reporting and fixing :)
> 
> Why is a forward declation needed, why isn't the function in the 
> proper spot in the file to begin with?

There is no reason, ftrace-related things can also be moved on top.
Borislav, could you move it?

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


