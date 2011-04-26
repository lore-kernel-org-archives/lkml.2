Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1DZWmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 18:42:04 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.39.38]:46075 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932391Ab1DZWmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 18:42:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=qTA5/x/l4s7GzkwcT3Xf5J1l730qzqdygOEJlMxFCmwQSEIjuocYeU75A88YbCAvKy3IfaLsWuD78lWvti9s/NbHs6XugI00vTAaMf6HpfvRAo/r5aiP2PfeoLT0fmL1;
Date: Tue, 26 Apr 2011 15:42:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Cyril Brulebois <kibi@debian.org>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 1/4] Documentation/00-INDEX: fix typo
Message-Id: <20110426154200.499f2d06.rdunlap@xenotime.net>
In-Reply-To: <1303575344-10403-1-git-send-email-kibi@debian.org>
References: <1303575344-10403-1-git-send-email-kibi@debian.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Apr 2011 18:15:41 +0200 Cyril Brulebois wrote:

> Signed-off-by: Cyril Brulebois <kibi@debian.org>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  Documentation/00-INDEX |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> index c17cd4b..7be2510 100644
> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -71,7 +71,7 @@ atomic_ops.txt
>  auxdisplay/
>  	- misc. LCD driver documentation (cfag12864b, ks0108).
>  basic_profiling.txt
> -	- basic instructions for those who wants to profile Linux kernel.
> +	- basic instructions for those who want to profile Linux kernel.
>  binfmt_misc.txt
>  	- info on the kernel support for extra binary formats.
>  blackfin/
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
