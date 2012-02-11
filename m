Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2BKXxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:53:52 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23855 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2BKXxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:53:51 -0500
Date: Sun, 12 Feb 2012 00:54:31 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg KH <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Staging: bcm: Don't leak 'pstAddIndication' in
 CmHost.c::StoreCmControlResponseMessage()
In-Reply-To: <20120210180037.GA588@kroah.com>
Message-ID: <alpine.LNX.2.00.1202120051310.7100@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net> <alpine.LNX.2.00.1201242346380.27508@swampdragon.chaosbits.net> <20120209175217.GA13959@kroah.com> <alpine.LNX.2.00.1202092329110.32491@swampdragon.chaosbits.net>
 <20120210180037.GA588@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012, Greg KH wrote:

> On Thu, Feb 09, 2012 at 11:33:25PM +0100, Jesper Juhl wrote:
> > From: Jesper Juhl <jj@codesealer.com>
> > 
> > We allocate memory for 'pstAddIndication' with kmalloc() in
> > drivers/staging/bcm/CmHost.c::StoreCmControlResponseMessage() and then
> > neglect to free it on a number of exit paths from that function.
> > 
> > This could probably be resolved cleaner/nicer, but this file needs a
> > serious overhaul in any case, so I opted for just fixing the problem
> > as directly as I could and then we can clean it up generally
> > later... This at least makes it stop bleeding..
> > 
> > Signed-off-by: Jesper Juhl <jj@codesealer.com>
> 
> Odd, didn't I already apply this patch?
> 
> confused,
> 

Well, you were the one who (in email message with Message-ID: 
<20120209175217.GA13959@kroah.com>) said that it no longer applied and 
asked for a resubmit against linux-next:

  "This patch no longer applies, care to redo it against the latest
  linux-next tree?"

So I just did what you asked :-)

Whether or not you have already applied it somewhere else I have no 
idea...

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

