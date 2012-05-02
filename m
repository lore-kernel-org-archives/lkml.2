Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab2EBF0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 01:26:11 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:45840 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab2EBF0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 01:26:10 -0400
Message-ID: <4FA0C553.7010902@linux.vnet.ibm.com>
Date: Wed, 02 May 2012 10:55:39 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Rob Landley <rob@landley.net>
Subject: Re: [PATCH] Documentation: power: suspend-and-cpuhotplug.txt: Fix
 typo
References: <1335911272-5907-1-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1335911272-5907-1-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050205-3864-0000-0000-000002842671
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 03:57 AM, Marcos Paulo de Souza wrote:

> sysfs was expected in this context.
> 
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Rob Landley <rob@landley.net>
> Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> ---


Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

 
Regards,
Srivatsa S. Bhat

>  Documentation/power/suspend-and-cpuhotplug.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.txt
> index f28f9a6..e13dafc 100644
> --- a/Documentation/power/suspend-and-cpuhotplug.txt
> +++ b/Documentation/power/suspend-and-cpuhotplug.txt
> @@ -29,7 +29,7 @@ More details follow:
> 
>                                    Write 'mem' to
>                                  /sys/power/state
> -                                    syfs file
> +                                    sysfs file
>                                          |
>                                          v
>                                 Acquire pm_mutex lock


