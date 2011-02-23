Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1BWKpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:45:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab1BWKpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:45:31 -0500
Message-ID: <4D64E540.9030702@redhat.com>
Date: Wed, 23 Feb 2011 07:45:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
Subject: Re: [PATCH 18/18] MAINTAINERS: Update WINBOND CIR pattern
References: <cover.1298439175.git.joe@perches.com> <ea1ef222215810169e9dd4c29b2e5c03cbd667e1.1298439175.git.joe@perches.com>
In-Reply-To: <ea1ef222215810169e9dd4c29b2e5c03cbd667e1.1298439175.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-02-2011 02:42, Joe Perches escreveu:
> commit 5b2e303f6df1e0b1a903950c5d613a20c8c71a37
> ("[media] rc-core: convert winbond-cir")
> moved the files, update the pattern.
> 
> cc: David Härdeman <david@hardeman.nu>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2b4dfa4..c0548be 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6787,7 +6787,7 @@ F:	drivers/scsi/wd7000.c
>  WINBOND CIR DRIVER
>  M:	David Härdeman <david@hardeman.nu>
>  S:	Maintained
> -F:	drivers/input/misc/winbond-cir.c
> +F:	drivers/media/rc/winbond-cir.c
>  
>  WIMAX STACK
>  M:	Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>

