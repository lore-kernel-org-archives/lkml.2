Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124Ab1EZBeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 21:34:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60381 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab1EZBed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 21:34:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDDADF3.30507@jp.fujitsu.com>
Date: Thu, 26 May 2011 10:33:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com> <1305619719-7480-6-git-send-email-ying.huang@intel.com> <20110517084622.GE22093@elte.hu> <4DD23750.3030606@intel.com> <20110517092620.GI22093@elte.hu> <4DD31C78.6000209@intel.com> <20110520115614.GH14745@elte.hu> <BANLkTi=5Y0fqsmhsoPm8si=nQBc-tCwtrw@mail.gmail.com> <20110522100021.GA28177@elte.hu> <4DDCB294.9000405@jp.fujitsu.com> <20110525141115.GE19118@elte.hu>
In-Reply-To: <20110525141115.GE19118@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/25 23:11), Ingo Molnar wrote:
> No, i think your patch is already a pretty nice simplification of the 
> MCE code - using irq_work is obviously better than the open-coded MCE 
> vector approach!
> 
> These are exactly the kind of small steps towards generalizations 
> that i wanted to see: each step without being intrusive and breaking 
> stuff and working towards improving the status quo.

Thank you, Ingo!

I have some minor patches for mce codes too so I'll post this and those
in new thread soon.

Thanks,
H.Seto

