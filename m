Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab0CaCoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:44:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:35111 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab0CaCoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:44:38 -0400
Message-ID: <4BB2B6C4.8090803@kernel.org>
Date: Wed, 31 Mar 2010 11:43:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Steven Rostedt <rostedt@goodmis.org>, stable <stable@kernel.org>
Subject: Re: [PATCH] lockdep fix incorrect percpu usage
References: <20100330033425.GD7683@Krystal> <1269938876.5109.510.camel@twins> <20100330134555.GA20673@Krystal> <1269959111.5258.142.camel@laptop> <20100330150551.GA22312@Krystal>
In-Reply-To: <20100330150551.GA22312@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 31 Mar 2010 02:43:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 12:05 AM, Mathieu Desnoyers wrote:
> I see. These patches are "on their way" to mainline, so it's better not to
> create conflicts. So the lockdep patch should only be applied to -stable, but
> separate module.c patch should apply to both -stable and mainline. Am I
> correct ?

I'll push proper fixes to mainline in a few days.  For -stable, yeah,
probably.

Thanks.

-- 
tejun
