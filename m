Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1BHCkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:40:31 -0500
Received: from xenotime.net ([72.52.115.56]:38438 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754153Ab1BHCka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 21:40:30 -0500
Date: Mon, 7 Feb 2011 18:40:27 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Harry Wei <jiaweiwei.xiyou@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
        davem@davemloft.net, greg@kroah.com
Subject: Re: [PATCH]Maintain Chinese Documentations
Message-Id: <20110207184027.468e2a03.rdunlap@xenotime.net>
In-Reply-To: <20110208023735.GA4599@gmail.com>
References: <20110208023735.GA4599@gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011 10:37:37 +0800 Harry Wei wrote:

> Hi us,
>      I have translated some documentations of kernel so i want to maintain Chinese documentation in our kernel directories.
>      Following is my patcher for it.
> 
>      Thanks.
>      Best Regards.
>      Harry Wei.
>      
>      
> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  MAINTAINERS |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 531c5cf..dc0279e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6976,6 +6976,12 @@ S:	Maintained
>  F:	drivers/net/pptp.c
>  W:	http://sourceforge.net/projects/accel-pptp
>  
> +CHINESE DOCUMENTATION
> +M:	Harry Wei <harryxiyou@gmail.com>
> +L:	xiyoulinuxkernelgroup@googlegroups.com
> +S:	Maintained
> +F:	Documentation/zh_CN/
> +

Hi Harry,

Entries in the MAINTAINERS file are in alphabetical order, so "CHINESE DOCUMENTATION"
should come between CHECKPATCH and CISCO VIC ETHERNET NIC DRIVER.


>  THE REST
>  M:	Linus Torvalds <torvalds@linux-foundation.org>
>  L:	linux-kernel@vger.kernel.org
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
