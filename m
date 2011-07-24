Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab1GXSPv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 14:15:51 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49558 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752398Ab1GXSPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 14:15:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Mpk8tDm9UtwA+4FWap1Ez/ZgmXI65fhVs03Mx7y5YjX1/Eg601saeeC5d0dRDOdNgVXuUXHlh1BDN4KSze2L9kFHCpfqwyzmss6uldKEwkmGmwgEckZFrTWh6n/WgGKT;
Date: Sun, 24 Jul 2011 11:15:42 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Luis de Bethencourt <luis@debethencourt.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] Documentation/kernel-docs.txt: remove linux source
Message-Id: <20110724111542.1490ea53.rdunlap@xenotime.net>
In-Reply-To: <CAPA4HGXsH4T9i1zbMhYDis5NBR7R_x0W=s8HHeNDXajnXDzCSA@mail.gmail.com>
References: <CAPA4HGXsH4T9i1zbMhYDis5NBR7R_x0W=s8HHeNDXajnXDzCSA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jul 2011 12:07:10 +0200 Luis de Bethencourt wrote:

> Dropping LSD (Linux Source Driver) since it hasn't been available
> for a long time.
> 
> Signed-off-by: Luis de Bethencourt <luis@debethencourt.com>

Applied, thanks.

> ---
>  Documentation/kernel-docs.txt |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/kernel-docs.txt b/Documentation/kernel-docs.txt
> index 9a86746..0e0734b 100644
> --- a/Documentation/kernel-docs.txt
> +++ b/Documentation/kernel-docs.txt
> @@ -620,17 +620,6 @@
>         (including this document itself) have been moved there, and might
>         be more up to date than the web version.
> 
> -     * Name: "Linux Source Driver"
> -       URL: http://lsd.linux.cz
> -       Keywords: Browsing source code.
> -       Description: "Linux Source Driver (LSD) is an application, which
> -       can make browsing source codes of Linux kernel easier than you can
> -       imagine. You can select between multiple versions of kernel (e.g.
> -       0.01, 1.0.0, 2.0.33, 2.0.34pre13, 2.0.0, 2.1.101 etc.). With LSD
> -       you can search Linux kernel (fulltext, macros, types, functions
> -       and variables) and LSD can generate patches for you on the fly
> -       (files, directories or kernel)".
> -
>       * Name: "Linux Kernel Source Reference"
>         Author: Thomas Graichen.
>         URL: http://marc.info/?l=linux-kernel&m=96446640102205&w=4
> -- 
> 1.7.5.3
> --
> To unsubscribe from this list: send the line "unsubscribe linux-doc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
