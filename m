Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1KFQjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 11:39:19 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:57389 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753457Ab1KFQjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 11:39:17 -0500
Message-ID: <4EB6B7FB.3080005@xenotime.net>
Date: Sun, 06 Nov 2011 08:38:19 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Fix typo in freezer-subsystem.txt
References: <201111060112.05964.rjw@sisk.pl>
In-Reply-To: <201111060112.05964.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2011 05:12 PM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix a typo in Documentation/cgroups/freezer-subsystem.txt.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

You are welcome to merge this with PM patches.. or did you want
me to merge it?

> ---
>  Documentation/cgroups/freezer-subsystem.txt |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-3.0-SLE11-SP2/Documentation/cgroups/freezer-subsystem.txt
> ===================================================================
> --- linux-3.0-SLE11-SP2.orig/Documentation/cgroups/freezer-subsystem.txt
> +++ linux-3.0-SLE11-SP2/Documentation/cgroups/freezer-subsystem.txt
> @@ -33,9 +33,9 @@ demonstrate this problem using nested ba
>  
>  	From a second, unrelated bash shell:
>  	$ kill -SIGSTOP 16690
> -	$ kill -SIGCONT 16990
> +	$ kill -SIGCONT 16690
>  
> -	<at this point 16990 exits and causes 16644 to exit too>
> +	<at this point 16690 exits and causes 16644 to exit too>
>  
>  This happens because bash can observe both signals and choose how it
>  responds to them.
> --


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
