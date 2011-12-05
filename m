Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1LEFkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 00:40:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab1LEFkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 00:40:41 -0500
Message-ID: <4EDC594D.5040008@redhat.com>
Date: Mon, 05 Dec 2011 13:40:29 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Please add my tree to linux-next
References: <4ED8529E.5070608@redhat.com> <20111205100930.1bedc458a5e78b85c563465d@canb.auug.org.au>
In-Reply-To: <20111205100930.1bedc458a5e78b85c563465d@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年12月05日 07:09, Stephen Rothwell 写道:
> Hi,
>
> On Fri, 02 Dec 2011 12:22:54 +0800 Cong Wang<amwang@redhat.com>  wrote:
>>
>> As Andrew Morton suggested, please add my tree which contains all
>> of my patches for kmap_atomic() [1] to linux-next. Some of the
>> individual patches already got ACK from subsystem maintainers.
>> The tree is hosted on github:
>>
>>       git://github.com/congwang/linux.git #kmap_atomic
>
> I have added this tree to linux-next today.
>
> Thanks for adding your subsystem tree as a participant of linux-next.  As
> you may know, this is not a judgment of your code.  The purpose of
> linux-next is for integration testing and to lower the impact of
> conflicts between subsystems in the next merge window.
>
> You will need to ensure that the patches/commits in your tree/series have
> been:
>       * submitted under GPL v2 (or later) and include the Contributor's
> 	Signed-off-by,

When I sent the patches out, they all have my Signed-off-by, but not in the
commit logs in my tree. Is this a problem?

>       * posted to the relevant mailing list,

Yes, see http://lkml.org/lkml/2011/11/27/2.

>       * reviewed by you (or another maintainer of your subsystem tree),

Yes.

>       * successfully unit tested, and

Yes, compile-tested on x86_64 and ppc.

>       * destined for the current or next Linux merge window.

Yes, for next merge window.

>
> Basically, this should be just what you would send to Linus (or ask him
> to fetch).  It is allowed to be rebased if you deem it necessary.
>

Ok.

Thanks!
