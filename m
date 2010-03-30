Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0C3CKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 22:10:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:47716 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0C3CK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 22:10:29 -0400
Message-ID: <4BB15E1E.70504@kernel.org>
Date: Tue, 30 Mar 2010 11:12:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, stable <stable@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH 2.6.29.x - 2.6.31.1] module: fix	__module_ref_addr()
References: <20100327143126.GA25615@Krystal> <1269890492.19685.4767.camel@gandalf.stny.rr.com> <20100329200946.GA1618@Krystal> <20100329210722.GA14993@kroah.com>
In-Reply-To: <20100329210722.GA14993@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 30 Mar 2010 02:09:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On 03/30/2010 06:07 AM, Greg KH wrote:
>> Yes. 2.6.34-rc does not have this issue anymore, but the patch is needed in
>> -stable.
> 
> Why is this not in .34-rc2?  Can you find the specific patch in Linus's
> tree that solves this and let stable@kernel.org know about it?

For 2.6.34, the following two patches should remove the problem.
They're not in mainline yet but should appear in linux-next soon and
after a few days, I'll push them to Linus.

 http://thread.gmane.org/gmane.linux.kernel/958794/focus=959493

Thanks.

-- 
tejun
