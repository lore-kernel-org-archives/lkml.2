Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab0GVVim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:38:42 -0400
Received: from xenotime.net ([72.52.115.56]:33764 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752988Ab0GVVij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:38:39 -0400
Date: Thu, 22 Jul 2010 14:38:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 35/35]Documentation/HOWTO update web address.
Message-Id: <20100722143836.ecbed9c7.rdunlap@xenotime.net>
In-Reply-To: <1279687982-29413-5-git-send-email-justinmattock@gmail.com>
References: <1279687982-29413-1-git-send-email-justinmattock@gmail.com>
	<1279687982-29413-5-git-send-email-justinmattock@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010 21:52:52 -0700 Justin P. Mattock wrote:

> The patch below updates some borken web addresses.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  Documentation/HOWTO |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/HOWTO b/Documentation/HOWTO
> index 40ada93..365bda9 100644
> --- a/Documentation/HOWTO
> +++ b/Documentation/HOWTO
> @@ -187,7 +187,7 @@ apply a patch.
>  If you do not know where you want to start, but you want to look for
>  some task to start doing to join into the kernel development community,
>  go to the Linux Kernel Janitor's project:
> -	http://janitor.kernelnewbies.org/
> +	http://kernelnewbies.org/KernelJanitors	
>  It is a great place to start.  It describes a list of relatively simple
>  problems that need to be cleaned up and fixed within the Linux kernel
>  source tree.  Working with the developers in charge of this project, you
> @@ -315,7 +315,7 @@ process is tracked with the tool patchwork.  Patchwork offers a web
>  interface which shows patch postings, any comments on a patch or
>  revisions to it, and maintainers can mark patches as under review,
>  accepted, or rejected.  Most of these patchwork sites are listed at
> -http://patchwork.kernel.org/ or http://patchwork.ozlabs.org/.
> +http://patchwork.kernel.org/.


No need to drop patchwork.ozlabs.org -- it works.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
