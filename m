Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0LCWav (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:30:51 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0LCWau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:30:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W8h7kxuYBCyiA2MapsHn1EdVq/w9D6oZ3LRRY2FPpo9LBoc80AtN9U8nQnuDI510V+
         f8yTQUKRHio4/ob5D6SEVYaa6D+IEK+pLJs2gL2on5wpeuscpBvDk4Jx1CkNZN+H4oOT
         jiy4CkbwDgPNzHGeQ4Hj9Gn2e/Kqabv0wT7vE=
Date: Sat, 4 Dec 2010 00:30:43 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Xenofon Foukas <foukas.xenofon@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] Fix coding style issues in drivers.c
Message-ID: <20101203223043.GA28174@core2.telecom.by>
References: <1291411877-15579-1-git-send-email-foukas.xenofon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291411877-15579-1-git-send-email-foukas.xenofon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 11:31:17PM +0200, Xenofon Foukas wrote:
> This patch fixes line over 80 characters warning issues found
> in file drivers.c
> Signed-off-by: Xenofon Foukas <foukas.xenofon@gmail.com>

string literals shouldn't be broken because people grep for them.

> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -118,7 +118,8 @@ int comedi_device_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  	for (driv = comedi_drivers; driv; driv = driv->next) {
>  		if (!try_module_get(driv->module)) {
>  			printk
> -			    (KERN_INFO "comedi: failed to increment module count, skipping\n");
> +			     (KERN_INFO "comedi: failed to increment "
> +						"module count, skipping\n");
>  			continue;
>  		}
>  		if (driv->num_names) {
