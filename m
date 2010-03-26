Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0CZX6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 19:58:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:33941 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970Ab0CZX6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 19:58:07 -0400
Message-ID: <4BAD49AB.8070601@kernel.org>
Date: Fri, 26 Mar 2010 16:56:27 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Ian Campbell <ian.campbell@citrix.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/24] x86: Do not free zero sized per cpu areas
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-4-git-send-email-yinghai@kernel.org> <20100326234203.GD29222@cmpxchg.org> <4BAD47F6.3000003@kernel.org> <20100326235451.GE29222@cmpxchg.org>
In-Reply-To: <20100326235451.GE29222@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2010 04:54 PM, Johannes Weiner wrote:
> On Fri, Mar 26, 2010 at 04:49:10PM -0700, Yinghai Lu wrote:
>>
>> is there any chance that dump stack only print out address instead of function name ?
> 
> I suppose so, lacking frame pointers, but you still have
> filename + linenumber + 'wrong range'.

ok, will remove that function name.

