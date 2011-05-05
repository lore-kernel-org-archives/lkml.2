Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1EEWHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 18:07:23 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:53236 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752727Ab1EEWHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 18:07:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bdbGxQ1BOsnpyWEH6Zn6OQk53Hz4IX3k26yjJv5D9MyyjiwjtDPo2uDmSk+KNdM5cuXpxNd8vmW/09yNnUEjeWXUK07S3nRZbvq/t/IVDnub2cdcY11jwbOo+t7PAjYp;
Date: Thu, 5 May 2011 15:07:19 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fixes a small error in Documentation/HOWTO
Message-Id: <20110505150719.f4d480ad.rdunlap@xenotime.net>
In-Reply-To: <20110405020717.GA2506@gmail.com>
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
	<20110403045201.GA2598@gmail.com>
	<4D99230C.6040403@cn.fujitsu.com>
	<20110404111829.af8bc108.rdunlap@xenotime.net>
	<BANLkTinSC1UTEQxS0iCKu4tMX-9CUY3rJg@mail.gmail.com>
	<20110405020717.GA2506@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011 10:07:20 +0800 Harry Wei wrote:

> On Tue, Apr 05, 2011 at 09:59:55AM +0800, harryxiyou wrote:
> > On Tue, Apr 5, 2011 at 2:18 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> > 
> > > On Mon, 04 Apr 2011 09:46:52 +0800 Li Zefan wrote:
> > >
> > > > > Your updated link for HOWTO is just for linux-2.6.38. This link
> > > > > should be up-to-date kernel code. So i have corrected your
> > > > > patch like following.
> > > > >
> > > > > Thanks.
> > > > > Best Regards.
> > > > > Harry Wei.
> > > > >
> > > > > Signed-off-by: Someone Something <fordhaivat@gmail.com>
> > > > > Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> > > >
> > > > Did he sign the patch? If not, you can't do this, and Instead you
> > > > must ask him for his SOB.
> > > >
> > > > And I'll appreciate if you add:
> > > >
> > > >       From: Someone ...
> > > >
> > > > because your change is not significant enough to make you the author
> > > > of the patch.
> > >
> > > Regardless of that latter part, we cannot merge the patch from SS,
> > > like Xiaochen Wang said, since the name is false.
> Hi Randy,
>     I have corrected this patch like following. This may be well 
> for us.
> 
> Thanks.
> BR.
> Harry Wei.
> 
> From: Someone Something <fordhaivat@gmail.com>


Linus tells me that we don't want fake names or email addresses in
the development tree, so this won't do.

Harry, can you just send me a patch from you, with your Signed-off-by:
so that I can apply it, please?


> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  Documentation/HOWTO |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> index 365bda9..81bc1a9 100644
> --- a/Documentation/HOWTO
> +++ b/Documentation/HOWTO
> @@ -209,7 +209,7 @@ tools.  One such tool that is particularly recommended is the Linux
>  Cross-Reference project, which is able to present source code in a
>  self-referential, indexed webpage format. An excellent up-to-date
>  repository of the kernel code may be found at:
> -	http://users.sosdg.org/~qiyong/lxr/
> +	http://lxr.linux.no/+trees
>  
>  
>  The development process
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
