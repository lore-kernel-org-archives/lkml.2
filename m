Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab2BJSCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:02:31 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:62918 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2BJSCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:02:30 -0500
Date: Fri, 10 Feb 2012 10:00:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Staging: bcm: Don't leak 'pstAddIndication' in
 CmHost.c::StoreCmControlResponseMessage()
Message-ID: <20120210180037.GA588@kroah.com>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1201242346380.27508@swampdragon.chaosbits.net>
 <20120209175217.GA13959@kroah.com>
 <alpine.LNX.2.00.1202092329110.32491@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202092329110.32491@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 11:33:25PM +0100, Jesper Juhl wrote:
> From: Jesper Juhl <jj@codesealer.com>
> 
> We allocate memory for 'pstAddIndication' with kmalloc() in
> drivers/staging/bcm/CmHost.c::StoreCmControlResponseMessage() and then
> neglect to free it on a number of exit paths from that function.
> 
> This could probably be resolved cleaner/nicer, but this file needs a
> serious overhaul in any case, so I opted for just fixing the problem
> as directly as I could and then we can clean it up generally
> later... This at least makes it stop bleeding..
> 
> Signed-off-by: Jesper Juhl <jj@codesealer.com>

Odd, didn't I already apply this patch?

confused,

greg k-h
