Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1DSUJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:09:37 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:43625 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296Ab1DSUJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:09:35 -0400
From: Richard Weinberger <richard@nod.at>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] uml: fix hppfs build
Date: Tue, 19 Apr 2011 22:09:16 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.1-1.2-desktop; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Danner <danner.simon@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@infradead.org>
References: <BANLkTin1=uPcyBgy9S_2TJASk8qTkeueEA@mail.gmail.com> <20110419130419.5f1f8539.randy.dunlap@oracle.com>
In-Reply-To: <20110419130419.5f1f8539.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104192209.16816.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 19 April 2011, 22:04:19 schrieb Randy Dunlap:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Make HoneyPot ProcFS depend on CONFIG_PROC_FS so that it will build.
> Recommended by Christoph Hellwig.
> 
> Fixes kernel bugzilla #33692:
>   https://bugzilla.kernel.org/show_bug.cgi?id=33692
> 
> Reported-by: Simon Danner <danner.simon@gmail.com>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Jeff Dike <jdike@addtoit.com>
> Cc:	Richard Weinberger <richard@nod.at>
> Cc:	user-mode-linux-devel@lists.sourceforge.net
> Cc:	Christoph Hellwig <hch@infradead.org>
> ---
>  arch/um/Kconfig.um |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- lnx-2639-rc4.orig/arch/um/Kconfig.um
> +++ lnx-2639-rc4/arch/um/Kconfig.um
> @@ -47,7 +47,7 @@ config HOSTFS
> 
>  config HPPFS
>  	tristate "HoneyPot ProcFS (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	depends on EXPERIMENTAL && PROC_FS
>  	help
>  	  hppfs (HoneyPot ProcFS) is a filesystem which allows UML /proc
>  	  entries to be overridden, removed, or fabricated from the host.

Applied.

Thanks,
//richard
