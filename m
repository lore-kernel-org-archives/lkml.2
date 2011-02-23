Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1BWKpR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 05:45:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab1BWKpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 05:45:15 -0500
Message-ID: <4D64E52E.5090905@redhat.com>
Date: Wed, 23 Feb 2011 07:45:02 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeroen Vreeken <pe1rxq@amsat.org>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 17/18] MAINTAINERS: USB SE401 moved to staging, update
 pattern
References: <cover.1298439175.git.joe@perches.com> <b71216322abdb099ca0fc5a5fa997fa03ed773d0.1298439175.git.joe@perches.com>
In-Reply-To: <b71216322abdb099ca0fc5a5fa997fa03ed773d0.1298439175.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-02-2011 02:42, Joe Perches escreveu:
> And set the status to Orphan.
> 
> cc: Jeroen Vreeken <pe1rxq@amsat.org>
> cc: Hans Verkuil <hverkuil@xs4all.nl>
> cc: Mauro Carvalho Chehab <mchehab@redhat.com>

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cdab39b..2b4dfa4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6420,12 +6420,11 @@ S:	Maintained
>  F:	drivers/net/usb/rtl8150.c
>  
>  USB SE401 DRIVER
> -M:	Jeroen Vreeken <pe1rxq@amsat.org>
>  L:	linux-usb@vger.kernel.org
>  W:	http://www.chello.nl/~j.vreeken/se401/
> -S:	Maintained
> +S:	Orphan
>  F:	Documentation/video4linux/se401.txt
> -F:	drivers/media/video/se401.*
> +F:	drivers/staging/se401/
>  
>  USB SERIAL BELKIN F5U103 DRIVER
>  M:	William Greathouse <wgreathouse@smva.com>

