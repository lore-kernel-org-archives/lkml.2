Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab1DDSSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 14:18:33 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:39474 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754910Ab1DDSSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 14:18:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QGB/eFHX+63mKWXsXtgp7htwzdDhx/zli2+V56OOv8EtvKinq8tYol/lrIkNzqp8HwVVcm6eXh0luXdkgHRZrEwRkk4SZIshzWuOlrKmt5nnTPqw9VCiATa+y/wUSCRY;
Date: Mon, 4 Apr 2011 11:18:29 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Someone Something <fordhaivat@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, joe@perches.com,
        akpm@linux-foundation.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Fixes a small error in Documentation/HOWTO
Message-Id: <20110404111829.af8bc108.rdunlap@xenotime.net>
In-Reply-To: <4D99230C.6040403@cn.fujitsu.com>
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
	<20110403045201.GA2598@gmail.com>
	<4D99230C.6040403@cn.fujitsu.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Apr 2011 09:46:52 +0800 Li Zefan wrote:

> > Your updated link for HOWTO is just for linux-2.6.38. This link
> > should be up-to-date kernel code. So i have corrected your
> > patch like following.
> > 
> > Thanks.
> > Best Regards.
> > Harry Wei.
> > 
> > Signed-off-by: Someone Something <fordhaivat@gmail.com>
> > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> 
> Did he sign the patch? If not, you can't do this, and Instead you
> must ask him for his SOB.
> 
> And I'll appreciate if you add:
> 
> 	From: Someone ...
> 
> because your change is not significant enough to make you the author
> of the patch.

Regardless of that latter part, we cannot merge the patch from SS,
like Xiaochen Wang said, since the name is false.


> > ---
> >  Documentation/HOWTO |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> > index 365bda9..81bc1a9 100644
> > --- a/Documentation/HOWTO
> > +++ b/Documentation/HOWTO
> > @@ -209,7 +209,7 @@ tools.  One such tool that is particularly recommended is the Linux
> >  Cross-Reference project, which is able to present source code in a
> >  self-referential, indexed webpage format. An excellent up-to-date
> >  repository of the kernel code may be found at:
> > -	http://users.sosdg.org/~qiyong/lxr/
> > +	http://lxr.linux.no/+trees
> >  
> >  
> >  The development process


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
