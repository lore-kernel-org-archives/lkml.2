Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab1LILKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 06:10:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1LILKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 06:10:01 -0500
Message-ID: <4EE1EC7F.4060909@redhat.com>
Date: Fri, 09 Dec 2011 09:09:51 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Dmitri Belimov <d.belimov@gmail.com>,
        Stefan Ringel <linuxtv@stefanringel.de>
Subject: Re: [PATCH 2/8] MAINTAINERS: tm6000: Update F: patterns
References: <cover.1323418149.git.joe@perches.com> <c161ff9b75651d9da542fa657bc282ea25c508c5.1323418149.git.joe@perches.com>
In-Reply-To: <c161ff9b75651d9da542fa657bc282ea25c508c5.1323418149.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-12-2011 06:12, Joe Perches wrote:
> commit be30497085080 ("[media] move tm6000 to drivers/media/video")
> move the files, update the F: pattern.
>
> CC: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   MAINTAINERS |   10 +++++-----
>   1 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 04fb68c..149c676 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6375,11 +6375,6 @@ M:	Omar Ramirez Luna<omar.ramirez@ti.com>
>   S:	Odd Fixes
>   F:	drivers/staging/tidspbridge/
>
> -STAGING - TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
> -L:	linux-media@vger.kernel.org
> -S:	Odd Fixes
> -F:	drivers/staging/tm6000/
> -
>   STAGING - USB ENE SM/MS CARD READER DRIVER
>   M:	Al Cho<acho@novell.com>
>   S:	Odd Fixes
> @@ -6634,6 +6629,11 @@ F:	include/linux/trace*.h
>   F:	include/trace/
>   F:	kernel/trace/
>
> +TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
> +L:	linux-media@vger.kernel.org
> +S:	Odd Fixes
> +F:	drivers/media/video/tm6000/
> +

This driver is under my umbrella. I wrote it, and have a few devices
with it. Yet, currently, most of the patches nowadays come from
Stefan and Dmitri.

As the coding style and other serious bugs were fixed already, the
"S" tag no no longer apply. "S: Maintained" fits better.

I would either remove this entry or add a new one, cloning from the
media entry, like:

TRIDENT TVMASTER TMxxxx USB VIDEO CAPTURE DRIVERS
M:	Mauro Carvalho Chehab <mchehab@infradead.org>
P:	LinuxTV.org Project
L:	linux-media@vger.kernel.org
W:	http://linuxtv.org
Q:	http://patchwork.kernel.org/project/linux-media/list/
T:	git git://linuxtv.org/media_tree.git
S:	Maintained

If we add a new entry, it probably makes sense to add Stefan
and/or Dmitri as co-maintainers there, if they're ok with that.

>   TRIVIAL PATCHES
>   M:	Jiri Kosina<trivial@kernel.org>
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git

