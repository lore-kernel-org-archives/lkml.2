Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387Ab2KAVwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 17:52:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26874 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762363Ab2KAVwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 17:52:39 -0400
Date: Thu, 1 Nov 2012 17:52:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: linux-next: manual merge of the tmem tree with the xen-two tree
Message-ID: <20121101215227.GA18854@localhost.localdomain>
References: <20121101144059.a8350c24499f1beffe59a64a@canb.auug.org.au>
 <20121101130310.GA11029@localhost.localdomain>
 <20121102001732.1c02f6a72c9cd2b894d9c6c4@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121102001732.1c02f6a72c9cd2b894d9c6c4@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 12:17:32AM +1100, Stephen Rothwell wrote:
> Hi Konrad,
> 
> On Thu, 1 Nov 2012 09:03:10 -0400 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >
> > I am not really sure how this happen - the 'tmem' tree should not have
> > had 7282a68f5aea, and more interestingly, I cannot find it in the
> > tmem tree! Either way, let me just reset the #linux-next to v3.7-rc3
> > in tmem tree and see if this shows up.
> 
> The version of the tmem tree I have has commit a728d5ea1c20 as its head
> and has the shortlog below.  I has not changed since Sept 24.

Oh, my. That is a mistake. I've reseted the #linux-next to be 3.7-rc3
in the tmem tree. It was not suppose to have that patch and I think
I just did 'git am' on the wrong tree. Thanks for catching this!

> 
> $ git shortlog origin/master..tmem/linux-next 
> Konrad Rzeszutek Wilk (3):
>       Merge commit 'v3.6-rc5' into linux-next
>       Merge branch 'stable/for-linus-3.7' into linux-next
>       Merge commit 'v3.6-rc6' into linux-next
> 
> Mukesh Rathor (1):
>       PVH: Basic and preparatory changes
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


