Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab2BIRwi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:52:38 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55167 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2BIRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:52:37 -0500
Date: Thu, 9 Feb 2012 09:52:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 2/2] Staging; Don't leak 'pstAddIndication' in
 CmHost.c::StoreCmControlResponseMessage()
Message-ID: <20120209175217.GA13959@kroah.com>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1201242346380.27508@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1201242346380.27508@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 11:47:27PM +0100, Jesper Juhl wrote:
> We allocate memory for 'pstAddIndication' with kmalloc() in
> drivers/staging/bcm/CmHost.c::StoreCmControlResponseMessage() and then
> neglect to free it on a number of exit paths from that function.
> 
> This could probably be resolved cleaner/nicer, but this file needs a
> serious overhaul in any case, so I opted for just fixing the problem
> as directly as I could and then we can clean it up generally
> later... This at least makes it stop bleeding..
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/staging/bcm/CmHost.c |   27 ++++++++++++++++++++-------
>  1 files changed, 20 insertions(+), 7 deletions(-)


This patch no longer applies, care to redo it against the latest
linux-next tree?

thanks,

greg k-h
