Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1DDBoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 21:44:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab1DDBoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 21:44:04 -0400
Message-ID: <4D99230C.6040403@cn.fujitsu.com>
Date: Mon, 04 Apr 2011 09:46:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Someone Something <fordhaivat@gmail.com>, greg@kroah.com,
        linux-kernel@vger.kernel.org, rdunlap@xenotime.net, joe@perches.com,
        akpm@linux-foundation.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Fixes a small error in Documentation/HOWTO
References: <AANLkTinHAfGi84LWzP2rCqpzB6nmj-B2jU_pEPf89Lcz@mail.gmail.com> <20110403045201.GA2598@gmail.com>
In-Reply-To: <20110403045201.GA2598@gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-04 09:42:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-04 09:42:26,
	Serialize complete at 2011-04-04 09:42:26
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your updated link for HOWTO is just for linux-2.6.38. This link
> should be up-to-date kernel code. So i have corrected your
> patch like following.
> 
> Thanks.
> Best Regards.
> Harry Wei.
> 
> Signed-off-by: Someone Something <fordhaivat@gmail.com>
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>

Did he sign the patch? If not, you can't do this, and Instead you
must ask him for his SOB.

And I'll appreciate if you add:

	From: Someone ...

because your change is not significant enough to make you the author
of the patch.

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
