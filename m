Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab2A0Xnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 18:43:31 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11751 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2A0Xna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 18:43:30 -0500
Date: Sat, 28 Jan 2012 00:43:39 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ilia Mirkin <imirkin@alum.mit.edu>, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH 1/2] Staging; bcm/CmHost.c: Style cleanup
In-Reply-To: <20120125062658.GR3294@mwanda>
Message-ID: <alpine.LNX.2.00.1201280037080.13952@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net> <alpine.LNX.2.00.1201242345140.27508@swampdragon.chaosbits.net> <20120125062658.GR3294@mwanda>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jan 2012, Dan Carpenter wrote:

> This is probably going to need to be redone on top of the other bcm
> cleanup patches anyway.
> 
If that turns out to be so, well, so be it. I was not aware of other 
patches, so my bad...

> On Tue, Jan 24, 2012 at 11:46:31PM +0100, Jesper Juhl wrote:
> > +		pstClassifierEntry->ucDestPortRangeLength
> > +			= psfCSType->cCPacketClassificationRule.u8ProtocolDestPortRangeLength/4;
> 
> Put the equals on the first line when you break something up like
> this. Also the real fix here is to choose shorter and better names
> than "cCPacketClassificationRule.u8ProtocolDestPortRangeLength".
> 
> If you're breaking up a condition normally the && or || go on the
> first line as well.
> 	if (foo &&
> 	    bar &&
> 	    baz) { ...
> 
> Although that's not in CodingStyle so it's not a "redo the patch"
> situation.
> 
As you say, "not in CodingStyle", so I guess it's down to your personal 
preference vs my personal preference vs what's most common in the kernel 
vs maintainers preference.

I did it the way I did for a reason.
I personally find that if one puts the '=', '==', '&&', '||', '+', 
<whatever> at the end of each line on a multi-line statement, then they 
are easy to overlook when just reading the code casually. If, however, one 
puts them at the start of each line, they stand out and are easier to see 
(harder to miss). That's why I did as I did. You may not agree, but at 
least now you know my reason for doing it the way I did.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

