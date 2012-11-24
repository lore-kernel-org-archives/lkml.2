Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab2KXIo0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:44:26 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:16361 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932756Ab2KXIoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:44:25 -0500
Date: Sat, 24 Nov 2012 09:44:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, "Mark M. Hoffman" <mhoffman@lightlink.com>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 13/24] MAINTAINERS: fix drivers/i2c/busses/i2c-stub.c
Message-ID: <20121124094413.35547dab@endymion.delvare>
In-Reply-To: <1353716808-16375-14-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
	<1353716808-16375-14-git-send-email-cesarb@cesarb.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cesar,

On Fri, 23 Nov 2012 22:26:37 -0200, Cesar Eduardo Barros wrote:
> This file was moved to drivers/i2c/i2c-stub.c by commit 31d178b
> (i2c-stub: Move to drivers/i2c).
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
> Cc: linux-i2c@vger.kernel.org
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 91feba2..eaf1a59 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3667,7 +3667,7 @@ I2C/SMBUS STUB DRIVER
>  M:	"Mark M. Hoffman" <mhoffman@lightlink.com>
>  L:	linux-i2c@vger.kernel.org
>  S:	Maintained
> -F:	drivers/i2c/busses/i2c-stub.c
> +F:	drivers/i2c/i2c-stub.c

Right. I thought I had fixed it meanwhile, but either I forgot or it
got lost along the way. Applied, thanks.

BTW, Mark has been away from linux kernel development for years now and
he did even not reply to my latest e-mail, so maybe it would be better
to drop his entries from MAINTAINERS altogether. Mark, please speak up.

-- 
Jean Delvare
