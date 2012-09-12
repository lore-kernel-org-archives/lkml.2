Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab2ILQKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:10:05 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:40737 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2ILQKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:10:03 -0400
Date: Wed, 12 Sep 2012 18:09:54 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] MAINTAINERS: fix tree for current i2c-embedded
 development
Message-ID: <20120912180954.69e3095e@endymion.delvare>
In-Reply-To: <1347466020-11836-1-git-send-email-w.sang@pengutronix.de>
References: <1347466020-11836-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2012 18:07:00 +0200, Wolfram Sang wrote:
> Guide people to where their patches can be found these days.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  MAINTAINERS |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fdc0119..53cc13c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3388,7 +3388,7 @@ M:	"Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
>  L:	linux-i2c@vger.kernel.org
>  W:	http://i2c.wiki.kernel.org/
>  T:	quilt kernel.org/pub/linux/kernel/people/jdelvare/linux-2.6/jdelvare-i2c/
> -T:	git git://git.fluff.org/bjdooks/linux.git
> +T:	git git://git.pengutronix.de/git/wsa/linux.git
>  S:	Maintained
>  F:	Documentation/i2c/
>  F:	drivers/i2c/

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
