Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030641Ab2CNCyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:54:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40515 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030491Ab2CNCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:54:09 -0400
Date: Tue, 13 Mar 2012 19:54:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrew Miller <amiller@amilx.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8187se: r8180_core.c: Fix coding style issue
Message-ID: <20120314025402.GD22955@kroah.com>
References: <1331686689-6763-1-git-send-email-amiller@amilx.com>
 <1331688836.27389.13.camel@joe2Laptop>
 <20120314014949.GB7156@iron>
 <1331691146.27389.20.camel@joe2Laptop>
 <20120314023342.GC7156@iron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314023342.GC7156@iron>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 10:33:42PM -0400, Andrew Miller wrote:
> Thanks, you help me alot
> 
> If you don't mind me asking a few more question.
> 
> Would fixing things like this
> 
> - if(x==y)
> + if(x == y)
> 
> be worthless? 

Yes, as it should really be:
	if (x == y)
:)

> Changing c++ style comment to c style? 

That's also good.

> And I should not wory about line being longer the 80 charactor, unless they are
> just extremely long?

If you feel it will read better, than yes, do it.

> I'm just over half way through my CS degree, so I'm a complete noob.
> I'm still learning what is not worth spending time on and what is.

This is worthwhile, if you want to do this.  Cleanups like this are a
great place to learn and get involved and become comfortable with the
codebase.

Just don't mix different fixes in the same patch.

And don't top post :)

thanks,

greg k-h
