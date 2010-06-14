Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0FNQ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 12:59:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:14537 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab0FNQ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 12:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,415,1272870000"; 
   d="scan'208";a="576254267"
Subject: Re: [PATCH 7/7] MAINTAINERS: Add patterns to WIMAX STACK
From: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <557e2d3330369558badc163da6215008ffc50ab1.1276304638.git.joe@perches.com>
References: <cover.1276304638.git.joe@perches.com>
	 <557e2d3330369558badc163da6215008ffc50ab1.1276304638.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 09:55:04 -0700
Message-ID: <1276534504.21431.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 18:06 -0700, Joe Perches wrote: 
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

You would be missing 

include/linux/wimax.h
include/linux/wimax/debug.h

[there is a file include/linux/wimax/i2400m.h that is part of the i2400m
driver, so I don't know if you could do include/linux/wimax*].

Thanks!

> ---
>  MAINTAINERS |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4cf783b..03cfc1c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6243,6 +6243,9 @@ M:	linux-wimax@intel.com
>  L:	wimax@linuxwimax.org
>  S:	Supported
>  W:	http://linuxwimax.org
> +F:	Documentation/wimax/README.wimax
> +F:	include/net/wimax.h
> +F:	net/wimax/
>  
>  WIMEDIA LLC PROTOCOL (WLP) SUBSYSTEM
>  M:	David Vrabel <david.vrabel@csr.com>



