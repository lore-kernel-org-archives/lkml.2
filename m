Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab2EETFQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:05:16 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55310 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab2EETFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:05:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Jones <davej@redhat.com>
Subject: Re: CPU frequency drivers MAINTAINERS update
Date: Sat, 5 May 2012 21:10:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <20120504160417.GA421@redhat.com>
In-Reply-To: <20120504160417.GA421@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205052110.03323.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On Friday, May 04, 2012, Dave Jones wrote:
> Remove myself as cpufreq maintainer.
> x86 driver changes can go through the regular x86/ACPI trees.
> ARM driver changes through the ARM trees.
> cpufreq core changes are rare these days, and can just go to lkml/direct.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Would you mind if I took over the maintenance of cpufreq, so that it goes
along with the other core power management code?

Rafael


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
>  F:	drivers/cpufreq/
>  F:	include/linux/cpufreq.h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

