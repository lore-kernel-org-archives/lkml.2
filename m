Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab1GSBnI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 21:43:08 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:45111 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977Ab1GSBnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 21:43:05 -0400
X-Sasl-enc: enKbd175HjiIec1si+v9pZ1LRGbCAHN/TN9D3hiLITmr 1311039782
Date: Mon, 18 Jul 2011 18:01:04 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-ID: <20110719010104.GA12591@kroah.com>
References: <20110718193646.33fb3f41db9d84974913657d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718193646.33fb3f41db9d84974913657d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 07:36:46PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allysconfig) failed like this:
> 
> In file included from drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:26:0:
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_read_reg':
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:80:2: error: implicit declaration of function 'inw'
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h: In function 'ft1000_write_reg':
> drivers/staging/ft1000/ft1000-pcmcia/ft1000.h:86:2: error: implicit declaration of function 'outw'

PowerPC supports PCMCIA?  Anyway, Ondrej, care to provide a fix for this
please?

thanks,

greg k-h
