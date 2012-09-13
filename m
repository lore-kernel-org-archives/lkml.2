Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792Ab2IMOh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 10:37:26 -0400
Received: from trinity.fluff.org ([89.16.178.74]:42896 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab2IMOhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 10:37:23 -0400
X-Greylist: delayed 2483 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2012 10:37:23 EDT
Date: Thu, 13 Sep 2012 14:55:58 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] MAINTAINERS: fix tree for current i2c-embedded
 development
Message-ID: <20120913135558.GB1095@trinity.fluff.org>
References: <1347466020-11836-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347466020-11836-1-git-send-email-w.sang@pengutronix.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 06:07:00PM +0200, Wolfram Sang wrote:
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

Acked-by: Ben Dooks <ben-linux@fluff.org>

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

