Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1LIKEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 05:04:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab1LIKE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 05:04:29 -0500
Message-ID: <4EE1DD23.9050403@redhat.com>
Date: Fri, 09 Dec 2011 08:04:19 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v3.2 05/10] MAINTAINERS: Update marvell ccic F: patterns
References: <cover.1323401278.git.joe@perches.com> <1d1251f2213424a52340275e411fcff2ff4b2385.1323401278.git.joe@perches.com>
In-Reply-To: <1d1251f2213424a52340275e411fcff2ff4b2385.1323401278.git.joe@perches.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-12-2011 02:21, Joe Perches wrote:
> Commit f8fc729870ee
> ("[media] marvell-cam: Move cafe-ccic into its own directory")
> moved the files, update the pattern.
>
> CC: Jonathan Corbet<corbet@lwn.net>
> CC: Mauro Carvalho Chehab<mchehab@redhat.com>

As you sent to akpm, c/c me, I'm assuming that Andrew will apply it. So:

Acked-by: Mauro Carvalho Chehab<mchehab@redhat.com>

Andrew,
Please let me know if you prefer to have this on my tree. It won't conflict
to any patch there anyway, so there's no difference on having it coming from
my tree or from yours.

Regards,
Mauro
>
> Signed-off-by: Joe Perches<joe@perches.com>
> ---
>   MAINTAINERS |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index df2bef0..6d98e5e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1671,7 +1671,7 @@ L:	linux-media@vger.kernel.org
>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
>   S:	Maintained
>   F:	Documentation/video4linux/cafe_ccic
> -F:	drivers/media/video/cafe_ccic*
> +F:	drivers/media/video/marvell-ccic/
>
>   CAIF NETWORK LAYER
>   M:	Sjur Braendeland<sjur.brandeland@stericsson.com>

