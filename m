Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab1KWGwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:52:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:56768 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758387Ab1KWGww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:52:52 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX184/WFs1Ik4derCj3sRUdZ9pW9uBZ/SAvowMyWkOd
	+WY/vV+GJStqSA
Message-ID: <4ECC983F.1080602@gmx.de>
Date: Wed, 23 Nov 2011 06:52:47 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Zac Storer <zac.3.14159@gmail.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Drivers: video: sbuslib: fixed a brace coding style
 issue
References: <1321591138-8334-1-git-send-email-zac.3.14159@gmail.com>
In-Reply-To: <1321591138-8334-1-git-send-email-zac.3.14159@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2011 04:38 AM, Zac Storer wrote:
> Fixed a brace coding style issue.
> 
> Signed-off-by: Zac Storer <zac.3.14159@gmail.com>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/sbuslib.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/sbuslib.c b/drivers/video/sbuslib.c
> index 37d764a..3c1de98 100644
> --- a/drivers/video/sbuslib.c
> +++ b/drivers/video/sbuslib.c
> @@ -76,7 +76,7 @@ int sbusfb_mmap_helper(struct sbus_mmap_map *map,
>  				map_offset = (physbase + map[i].poff) & POFF_MASK;
>  				break;
>  			}
> -		if (!map_size){
> +		if (!map_size) {
>  			page += PAGE_SIZE;
>  			continue;
>  		}

