Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046Ab2EXTtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 15:49:10 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:26300 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757849Ab2EXTtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 15:49:08 -0400
Message-ID: <4FBE907F.8040701@parallels.com>
Date: Thu, 24 May 2012 23:48:15 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>, Cyrill Gorcunov <gorcunov@openvz.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "skinsbursky@openvz.org" <skinsbursky@openvz.org>
Subject: Re: [rfc v2 0/7] procfs fdinfo extension v2
References: <20120523102541.382837149@openvz.org> <20120524180121.GK798@count0.beaverton.ibm.com>
In-Reply-To: <20120524180121.GK798@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 10:01 PM, Matt Helsley wrote:
> On Wed, May 23, 2012 at 02:25:41PM +0400, Cyrill Gorcunov wrote:
> 
> <snip>
> 
>>  - finally it would be great to have ability to attach tasks to
>>    frozen tasks cgroup to thaw them at one moment (the preliminary
>>    patch I've proposed pretty long ago, but Tejun was modifying cgroups
>>    code and asked to wait until 3.4 is release, so I didn't check
>>    the current status of task cgroups at moment, I've it in my todo list)
> 
> This still strikes me as the wrong way to go about freezing for c/r.
> You never explained why you had to do it this way. Why can't you inject
> the parasite thread, move that thread out of the cgroup-to-be-frozen,
> then freeze?

Matt, I think that Cyrill copied this from some old wishlist and I didn't update him
in time :(

The thing is that we seem to have resolved all the issues with freezing/unfreezing
the processes we're checkpoiting/restoring, and currently we are OK with the existing
ptrace functionality. No more modifications of freeze cgroup are required.

Cyrill?

> As best I can tell your reply last time only fleshed out the details
> of *how* you would like it to work, not *why it needs to* work that way:
> 
> 	http://lkml.org/lkml/2011/11/30/27
> 
> Cheers,
> 	-Matt Helsley
> 
> .
> 

