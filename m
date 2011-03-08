Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab1CHUJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 15:09:14 -0500
Received: from xenotime.net ([184.105.210.51]:52189 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752257Ab1CHUJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 15:09:13 -0500
Date: Tue, 8 Mar 2011 12:09:06 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Roland Kammerer <dev.rck@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/CodingStyle: fixed header file for
 pr_info() and pr_debug(). Removed unnecessary "Last updated" line
Message-Id: <20110308120906.bda1e8c1.rdunlap@xenotime.net>
In-Reply-To: <AANLkTim5w1wRPk=+GgVEm-k9fMBWGt513v9txyXF+kmJ@mail.gmail.com>
References: <AANLkTim5w1wRPk=+GgVEm-k9fMBWGt513v9txyXF+kmJ@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011 20:54:09 +0100 Roland Kammerer wrote:

> pr_info() and pr_debug() are in linux/printk.h
> Last updated is unnecessary, we have git for that
> 
> Signed-off-by: Roland Kammerer <dev.rck@gmail.com>
> ---
>  Documentation/CodingStyle |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 8bb3723..1cd3478 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -659,7 +659,7 @@ There are a number of driver model diagnostic
> macros in <linux/device.h>

Hi,
I have applied this to my patch queue, but I had to fix it first.
Please note & prevent in the future:  the long lines above were split (broken)
for you (or for us), probably by your email client.
Documentation/email-clients.txt may help you fix that.

>  which you should use to make sure messages are matched to the right device
>  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
>  dev_info(), and so forth.  For messages that aren't associated with a
> -particular device, <linux/kernel.h> defines pr_debug() and pr_info().
> +particular device, <linux/printk.h> defines pr_debug() and pr_info().
> 
>  Coming up with good debugging messages can be quite a challenge; and once
>  you have them, they can be a huge help for remote troubleshooting.  Such
> @@ -819,6 +819,3 @@ language C, URL: http://www.open-std.org/JTC1/SC22/WG14/
>  Kernel CodingStyle, by greg@kroah.com at OLS 2002:
>  http://www.kroah.com/linux/talks/ols_2002_kernel_codingstyle_talk/html/
> 
> ---
> -Last updated on 2007-July-13.
> -
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
