Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1EZHOx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:14:53 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33870 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779Ab1EZHOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:14:51 -0400
X-Sasl-enc: k+amruzu/ZGkbJlkMylS3DXqXVd8qiqv5c/WLvvqzy5z 1306394089
Date: Thu, 26 May 2011 00:15:06 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Antony Pavlov <antony@niisi.msk.ru>
Subject: Re: linux-next: build warning in Linus' tree
Message-ID: <20110526071506.GH29833@kroah.com>
References: <20110525103740.f8917fd8.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525103740.f8917fd8.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 10:37:40AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> In Linus' tree, today's linux-next build (powerpc ppc64_defconfig)
> produced this warning:
> 
> drivers/tty/serial/8250_pci.c:1457: warning: initialization from incompatible pointer type
> 
> Introduced by commit d9a0fbfd7bc5 ("serial: 8250_pci: add support for
> Cronyx Omega PCI multiserial board").
> 
> Sorry that I didn't notice this earlier.

Thanks, I'll work on this.

greg k-h
