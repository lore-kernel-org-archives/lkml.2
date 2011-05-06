Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1EFVna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:43:30 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59302 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751922Ab1EFVn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:43:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XSH0wlb6FIslcC2Dem7ywJUB+t2tVXlxuqKmOakRBq/gFE0KPGFEZWW8HDTFo/z6qZ43frcUQjbHFwiOnpC7LN+SzBPkn7/whQDnnDralejmjIGY2LmFJXIm15HQHmG4;
Date: Fri, 6 May 2011 14:43:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fixes a small error in Documentation/HOWTO
Message-Id: <20110506144324.e397d0d8.rdunlap@xenotime.net>
In-Reply-To: <20110505235548.GA2075@gmail.com>
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com>
	<20110403045201.GA2598@gmail.com>
	<4D99230C.6040403@cn.fujitsu.com>
	<20110404111829.af8bc108.rdunlap@xenotime.net>
	<BANLkTinSC1UTEQxS0iCKu4tMX-9CUY3rJg@mail.gmail.com>
	<20110405020717.GA2506@gmail.com>
	<20110505150719.f4d480ad.rdunlap@xenotime.net>
	<20110505235548.GA2075@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011 07:55:51 +0800 Harry Wei wrote:

> On Thu, May 05, 2011 at 03:07:19PM -0700, Randy Dunlap wrote:
> > 
> > Linus tells me that we don't want fake names or email addresses in
> > the development tree, so this won't do.
> > 
> > Harry, can you just send me a patch from you, with your Signed-off-by:
> > so that I can apply it, please?
> Hi Randy,
> 	My pleasure, the patch is below. If you have any other questions,
> please let me know.


Applied..  thanks, Harry.

> Thanks.
> Harry Wei.
> 
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
> 1.7.0.4
> 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
