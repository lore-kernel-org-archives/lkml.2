Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab1HHQkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:40:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41523 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1HHQkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:40:11 -0400
Subject: Re: [PATCH] regulator: fix regulator/consumer.h kernel-doc warning
From: Liam Girdwood <lrg@kernel.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        akpm <akpm@linux-foundation.org>
In-Reply-To: <20110803180902.4d31d143.rdunlap@xenotime.net>
References: <20110803180902.4d31d143.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 17:40:07 +0100
Message-ID: <1312821607.3316.4.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 18:09 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix kernel-doc warning about internal/private data by marking it
> as "private:" so that kernel-doc will ignore it.
> 
> Warning(include/linux/regulator/consumer.h:128): No description found for parameter 'ret'
> 
> Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
> ---
>  include/linux/regulator/consumer.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-3.0-git18.orig/include/linux/regulator/consumer.h
> +++ linux-3.0-git18/include/linux/regulator/consumer.h
> @@ -123,7 +123,7 @@ struct regulator_bulk_data {
>  	const char *supply;
>  	struct regulator *consumer;
>  
> -	/* Internal use */
> +	/* private: Internal use */
>  	int ret;
>  };

Applied.

Thanks

Liam

