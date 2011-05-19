Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934334Ab1ESTWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:22:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:47966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933955Ab1ESTWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:22:14 -0400
Message-ID: <4DD56DDE.6060003@infradead.org>
Date: Thu, 19 May 2011 16:22:06 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-media@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        gregkh@suse.de, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Igor M. Liplianin" <liplianin@netup.ru>
Subject: Re: Fw: [PATCH -next RESEND/still needed] staging: altera-jtag needs
 delay.h
References: <20110328082305.c6fa41d9.randy.dunlap@oracle.com>
In-Reply-To: <20110328082305.c6fa41d9.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 28-03-2011 12:23, Randy Dunlap escreveu:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> altera-jtag.c needs to include <linux/delay.h> to fix a build error:
> 
> drivers/staging/altera-stapl/altera-jtag.c:398: error: implicit declaration of function 'udelay'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> Cc: Igor M. Liplianin <liplianin@netup.ru>
> ---
>  drivers/staging/altera-stapl/altera-jtag.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Somehow I was supposed to know to send this to Mauro instead of to Greg,
> but I don't see anything in drivers/staging/altera-stapl/ that says that.

Ah, yes, we need to add a readme file there stating about that.

Greg, you may add it on your tree, or if you prefer, I can just add here for
my next upstream pull.

Thanks,
Mauro.

> 
> 
> --- linux-next-20110304.orig/drivers/staging/altera-stapl/altera-jtag.c
> +++ linux-next-20110304/drivers/staging/altera-stapl/altera-jtag.c
> @@ -23,6 +23,7 @@
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/delay.h>
>  #include <linux/firmware.h>
>  #include <linux/slab.h>
>  #include <staging/altera.h>
> --

