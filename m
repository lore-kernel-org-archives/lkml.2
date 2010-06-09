Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597Ab0FIXAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 19:00:36 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:65378
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758461Ab0FIXAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 19:00:35 -0400
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 19:00:35 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBALK3D0zL2Tdl/2dsb2JhbAAH3w+FGAQ
X-IronPort-AV: E=Sophos;i="4.53,394,1272816000"; 
   d="scan'208";a="663863586"
Subject: Re: [PATCH 08/12] MAINTAINERS: Remove section SMX UIO Interface
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <864afd7fe86e75278b76c1f32f2c85306c98d6e6.1276112117.git.joe@perches.com>
Date: Thu, 10 Jun 2010 08:51:12 +1000
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3D5B4F42-DD20-42BC-A22E-1F35B42D6949@niasdigital.com>
References: <cover.1276112117.git.joe@perches.com> <864afd7fe86e75278b76c1f32f2c85306c98d6e6.1276112117.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/06/2010, at 5:38 AM, Joe Perches wrote:

> commit d6e976c0d258c9547a308bd8a9a82ec93e2bc6e2
> removed the file
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Ben Nizette <bn@niasdigital.com>

Acked-by: Ben Nizette <bn@niasdigital.com>

Thanks!

> ---
> MAINTAINERS |    5 -----
> 1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 765322e..8aac474 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5226,11 +5226,6 @@ L:	netdev@vger.kernel.org
> S:	Supported
> F:	drivers/net/smsc9420.*
> 
> -SMX UIO Interface
> -M:	Ben Nizette <bn@niasdigital.com>
> -S:	Maintained
> -F:	drivers/uio/uio_smx.c
> -
> SN-IA64 (Itanium) SUB-PLATFORM
> M:	Jes Sorensen <jes@sgi.com>
> L:	linux-altix@sgi.com
> -- 
> 1.7.1.244.gbdc4
> 

