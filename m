Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab1HXEuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 00:50:40 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40695 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab1HXEug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 00:50:36 -0400
X-Sasl-enc: hj7YUpaRiQ4YJyCKZD1mLqhGyb5waW3qnfbaGLd1l9iA 1314161435
Date: Tue, 23 Aug 2011 21:50:23 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jamie Iles <jamie@jamieiles.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jamie Iles <jamie@jamieiles.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: linux-next: build failure after merge of the tty tree
Message-ID: <20110824045023.GB1122@kroah.com>
References: <20110824143354.d32c86b5143631442aca3700@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824143354.d32c86b5143631442aca3700@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 02:33:54PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/built-in.o: In function `dw8250_handle_irq':
> 8250_dw.c:(.text+0xcad9c): undefined reference to `serial8250_handle_irq'
> 
> CONFIG_SERIAL_8250 is 'm' and CONFIG_SERIAL_8250_DW is 'y' ...
> 
> Caused by commit 6b1a98d1c485 ("tty: serial8250: add helpers for the
> DesignWare 8250").
> 
> I have used the ttye tree form next-20110823 for today.

Ick.

Jamie, can you please send me a patch that fixes this up?

thanks,

greg k-h
