Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966335Ab2EQNSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 09:18:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58189 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761739Ab2EQNSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 09:18:49 -0400
Date: Thu, 17 May 2012 15:18:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Oskar Schirmer <oskar@scara.com>
Cc: linux-kernel@vger.kernel.org, hannes@cmpxchg.org, shess@hessware.de,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 4/5] lib: Change mail address of Oskar Schirmer
In-Reply-To: <1337161280-28953-5-git-send-email-oskar@scara.com>
Message-ID: <alpine.LNX.2.00.1205171518380.8796@pobox.suse.cz>
References: <1337161280-28953-1-git-send-email-oskar@scara.com> <1337161280-28953-5-git-send-email-oskar@scara.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012, Oskar Schirmer wrote:

> That old mail address doesnt exist any more.
> This changes all occurences to my new address.
> 
> Signed-off-by: Oskar Schirmer <oskar@scara.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  include/linux/rational.h |    2 +-
>  lib/rational.c           |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/rational.h b/include/linux/rational.h
> index 4f532fc..bfa6a2b 100644
> --- a/include/linux/rational.h
> +++ b/include/linux/rational.h
> @@ -1,7 +1,7 @@
>  /*
>   * rational fractions
>   *
> - * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <os@emlix.com>
> + * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <oskar@scara.com>
>   *
>   * helper functions when coping with rational numbers,
>   * e.g. when calculating optimum numerator/denominator pairs for
> diff --git a/lib/rational.c b/lib/rational.c
> index d326da3..f0aa21c 100644
> --- a/lib/rational.c
> +++ b/lib/rational.c
> @@ -1,7 +1,7 @@
>  /*
>   * rational fractions
>   *
> - * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <os@emlix.com>
> + * Copyright (C) 2009 emlix GmbH, Oskar Schirmer <oskar@scara.com>
>   *
>   * helper functions when coping with rational numbers
>   */

Applied.

-- 
Jiri Kosina
SUSE Labs
