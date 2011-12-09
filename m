Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1LIK6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:58:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1LIK6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:58:44 -0500
Message-ID: <4EE1E9DC.9090501@redhat.com>
Date: Fri, 09 Dec 2011 08:58:36 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] MAINTAINERS: staging: media: Update F: patterns
References: <cover.1323418149.git.joe@perches.com> <f0af8da0b1955d23ae18b4f9bf3d57665cef6c43.1323418149.git.joe@perches.com>
In-Reply-To: <f0af8da0b1955d23ae18b4f9bf3d57665cef6c43.1323418149.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-12-2011 06:12, Joe Perches wrote:
> commit 4860c73804c ("staging: Move media drivers to staging/media")
> moved the files, update the F: patterns.
>
> CC: Mauro Carvalho Chehab<mchehab@redhat.com>

Acked-by: Mauro Carvalho Chehab<mchehab@redhat.com>

>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   MAINTAINERS |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2173f6b..04fb68c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6322,7 +6322,7 @@ STAGING - LIRC (LINUX INFRARED REMOTE CONTROL) DRIVERS
>   M:	Jarod Wilson<jarod@wilsonet.com>
>   W:	http://www.lirc.org/
>   S:	Odd Fixes
> -F:	drivers/staging/lirc/
> +F:	drivers/staging/media/lirc/
>
>   STAGING - NVIDIA COMPLIANT EMBEDDED CONTROLLER INTERFACE (nvec)
>   M:	Julian Andres Klode<jak@jak-linux.org>
> @@ -6358,7 +6358,7 @@ F:	drivers/staging/sm7xx/
>   STAGING - SOFTLOGIC 6x10 MPEG CODEC
>   M:	Ben Collins<bcollins@bluecherry.net>
>   S:	Odd Fixes
> -F:	drivers/staging/solo6x10/
> +F:	drivers/staging/media/solo6x10/
>
>   STAGING - SPEAKUP CONSOLE SPEECH DRIVER
>   M:	William Hubbs<w.d.hubbs@gmail.com>

