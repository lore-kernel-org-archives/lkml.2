Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0DVIbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 04:31:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:39193 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab0DVIbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 04:31:47 -0400
Message-ID: <4BCED901.6090202@kernel.org>
Date: Wed, 21 Apr 2010 12:52:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH] lockdep fix incorrect percpu usage
References: <20100330033425.GD7683@Krystal> <1269938876.5109.510.camel@twins> <20100330134555.GA20673@Krystal> <1269959111.5258.142.camel@laptop> <20100330150551.GA22312@Krystal> <4BB2B6C4.8090803@kernel.org> <20100419182936.GI32347@kroah.com> <20100420143350.GA14622@Krystal>
In-Reply-To: <20100420143350.GA14622@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Apr 2010 08:30:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2010 04:33 PM, Mathieu Desnoyers wrote:
> Here is the updated patch, stating which mainline commit from Tejun
> fixes it by refactoring the code. I'll leave the decision to pick
> this targeted fix or Tejun refactoring into -stable up to you.

Ditto, please take this one.

Thanks.

-- 
tejun
