Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759214Ab2EDQuo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:50:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50008 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752220Ab2EDQun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:50:43 -0400
Message-ID: <1336150241.7920.17.camel@joe2Laptop>
Subject: Re: CPU frequency drivers MAINTAINERS update
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Fri, 04 May 2012 09:50:41 -0700
In-Reply-To: <20120504160417.GA421@redhat.com>
References: <20120504160417.GA421@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 12:04 -0400, Dave Jones wrote:
> Remove myself as cpufreq maintainer.
> x86 driver changes can go through the regular x86/ACPI trees.
> ARM driver changes through the ARM trees.
> cpufreq core changes are rare these days, and can just go to lkml/direct.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b81b261..fe89a16 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1968,10 +1968,7 @@ S:	Maintained
>  F:	drivers/net/ethernet/ti/cpmac.c
>  
>  CPU FREQUENCY DRIVERS
> -M:	Dave Jones <davej@redhat.com>
>  L:	cpufreq@vger.kernel.org
> -W:	http://www.codemonkey.org.uk/projects/cpufreq/
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
>  S:	Maintained

If there's no maintainer, it's not really maintained.

Maybe:

S:	Orphan


