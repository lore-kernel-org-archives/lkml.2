Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1DNLiL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:38:11 -0400
Received: from ozlabs.org ([203.10.76.45]:34274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1DNLiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:38:10 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>, Amit Shah <amit.shah@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Liguori <aliguori@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [RFC][PATCH] virtio balloon: kill tell-host-first logic
In-Reply-To: <1302625352.8321.2126.camel@nimitz>
References: <20110407174325.ED21C82B@kernel> <20110411110131.GA23123@redhat.com> <1302559871.7286.16749.camel@nimitz> <20110412054330.GH26678@amit-x200.redhat.com> <1302625352.8321.2126.camel@nimitz>
User-Agent: Notmuch/0.3.1 (http://notmuchmail.org) Emacs/23.1.1 (i686-pc-linux-gnu)
Date: Thu, 14 Apr 2011 21:07:41 +0930
Message-ID: <878vvdawsa.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Apr 2011 09:22:32 -0700, Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> On Tue, 2011-04-12 at 11:13 +0530, Amit Shah wrote:
> > Sure, the only contention was on the commit message, where you stated
> > modern qemus set this... qemu doesn't, and it should.  Care to do a
> > patch for that? 
> 
> If Rusty hasn't pushed the commit out anywhere, we can still amend the
> commit.  Otherwise, we're in a _bit_ of a pickle since you can't patch
> git logs. :)

I only use git to send patches to Linus, and even if I did, I certainly
wouldn't try to publish an non-rebasing tree for exactly this reason.

So send me the new commit, or just the new message...

Thanks,
Rusty.
