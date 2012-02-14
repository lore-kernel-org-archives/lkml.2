Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761344Ab2BNWvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 17:51:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43075 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761264Ab2BNWvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 17:51:37 -0500
Date: Tue, 14 Feb 2012 14:51:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: [patch 0/4] Resending, c/r series v2
Message-Id: <20120214145136.fa400757.akpm@linux-foundation.org>
In-Reply-To: <20120213164822.227219834@openvz.org>
References: <20120213164822.227219834@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Feb 2012 20:48:22 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Hi, this series hopefully in a good shape
> 
>  - sys_kcmp now depends on CONFIG_CHECKPOINT_RESTORE
> 
>  - the extension of /proc/pid/stat now done against
>    linux-next/master
> 
> Please letme know if I've missed something.

Thus far our (my) approach has been to trickle the c/r support code
into mainline as it is developed.  Under the assumption that the end
result will be acceptable and useful kernel code.

I'm afraid that I'm losing confidence in that approach.  We have this
patchset, we have Stanislav's "IPC: checkpoint/restore in userspace
enhancements" (which apparently needs to get more complex to support
LSM context c/r).  I simply *don't know* what additional patchsets are
expected.  And from what you told me it sounds like networking support
is at a very early stage and I fear for what the end result of that
will look like.

So I don't feel that I can continue feeding these things into mainline
until someone can convince me that we won't have a nasty mess (and/or
an unsufficiently useful feature) at the end of the project.


The traditional approach is to develop the feature out-of-tree until it
is "finished".  That's a lot more hackwork for you guys and it leads to
a poorer feature - this approach inevitably has a lower level of review
and inhibits code rework.


An alternative is for me to buffer the patches in my tree until it is
all sufficiently finished.  That also is more work for your team, but
it will produce better code, because of additional review and code
rework resulting from that review.

I don't know how many patches that would end up being (this is part of
the problem!) nor how long they would be carried for.


So.  Please talk to me.  How long is this all going to take, and what
will the final result look like?

