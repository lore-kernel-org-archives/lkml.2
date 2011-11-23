Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1KWSUE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 13:20:04 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:28744 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1KWSUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 13:20:02 -0500
Message-ID: <4ECD3946.1030503@parallels.com>
Date: Wed, 23 Nov 2011 22:19:50 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Pedro Alves <pedro@codesourcery.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given
 pids
References: <4EC4F2FB.408@parallels.com> <201111221204.39235.pedro@codesourcery.com> <20111122153326.GD322@google.com> <201111231620.45440.pedro@codesourcery.com> <20111123162417.GE25780@google.com>
In-Reply-To: <20111123162417.GE25780@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2011 08:24 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 23, 2011 at 04:20:44PM +0000, Pedro Alves wrote:
>>> Would CAP_CHECKPOINT be a shame too?  
>>
>> I think CAP_CHECKPOINT (or something through some LSM) would be
>> definitely better.
>>
>>> I'm reluctant about priviledge
>>> through fd inheritance mostly because of its unusualness.  I don't
>>> think priv management is a good problem space for small creative
>>> solutions.  We're much better off with mundane mechanisms which people
>>> are already familiar with and is easy to account for.
>>
>> fd inheritance wouldn't work for gdb; a user spawned gdb
>> wouldn't inherit an open fd to kernel.ns_last_pid from anywhere.
> 
> I see.  So, let's do it for root for now and later add finer grained
> CAP as necessary/viable.  Pavel, what do you think?

OK, I'll send the respective patches soon.

> Thanks.
> 

