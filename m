Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab1KFJka (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 04:40:30 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:52806 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1KFJk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 04:40:29 -0500
Message-ID: <4EB65603.1030105@linux.vnet.ibm.com>
Date: Sun, 06 Nov 2011 15:10:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] Documentation: Fix typo in freezer-subsystem.txt
References: <201111060112.05964.rjw@sisk.pl>
In-Reply-To: <201111060112.05964.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11110609-2674-0000-0000-000001179419
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 05:42 AM, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Fix a typo in Documentation/cgroups/freezer-subsystem.txt.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Thanks,
Srivatsa S. Bhat

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
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

