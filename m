Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab1CDRfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 12:35:52 -0500
Received: from xenotime.net ([184.105.210.51]:50472 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759270Ab1CDRfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 12:35:51 -0500
Date: Fri, 4 Mar 2011 09:35:48 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux@kbdbabel.org, romfs@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, greg@kroah.com, akpm@linux-foundation.org
Subject: Re: [PATCH]fix a link in Documentation/filesystem/romfs.txt
Message-Id: <20110304093548.a37e0ef9.rdunlap@xenotime.net>
In-Reply-To: <20110304115926.GA4104@gmail.com>
References: <20110304115926.GA4104@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011 19:59:31 +0800 Harry Wei wrote:

> Hi us,
>     I think it is a good patch for Documentation/filesystem/romfs.txt.
> 
>    From: Alexander Kurz <linux@kbdbabel.org>
> 
> Hello romfs group,
> 	 I have posted a patch to fix the reference to
> the outdated ftp site (which still serves genromfs-0.5.1) in
> Documentation/filesystems/romfs.txt last month,
> but nobody has picked it up yet.
> 
> Does anybody like to forward this?
> Thanks, Alexander

Hi Jiri,
Do you have this merged somewhere?

Thanks.

> Thanks.
> Best Regards.
> Harry Wei.
> 
> Signed-off-by: Alexander Kurz<linux@kbdbabel.org>
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  Documentation/filesystems/romfs.txt |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/romfs.txt b/Documentation/filesystems/romfs.txt
> index 2d2a7b2..3b7ef40 100644
> --- a/Documentation/filesystems/romfs.txt
> +++ b/Documentation/filesystems/romfs.txt
> @@ -17,8 +17,7 @@ comparison, an actual rescue disk used up 3202 blocks with ext2, while
>  with romfs, it needed 3079 blocks.
>  
>  To create such a file system, you'll need a user program named
> -genromfs.  It is available via anonymous ftp on sunsite.unc.edu and
> -its mirrors, in the /pub/Linux/system/recovery/ directory.
> +genromfs. It is available on http://romfs.sourceforge.net.
>  
>  As the name suggests, romfs could be also used (space-efficiently) on
>  various read-only media, like (E)EPROM disks if someone will have the
> -- 



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
