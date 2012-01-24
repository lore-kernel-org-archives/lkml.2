Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2AXXRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:17:34 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16438 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab2AXXRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:17:32 -0500
Date: Wed, 25 Jan 2012 00:17:36 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH 1/2] Staging; bcm/CmHost.c: Style cleanup
In-Reply-To: <1327446791.15724.0.camel@joe2Laptop>
Message-ID: <alpine.LNX.2.00.1201250016090.27508@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1201242338500.27508@swampdragon.chaosbits.net>  <alpine.LNX.2.00.1201242345140.27508@swampdragon.chaosbits.net> <1327446791.15724.0.camel@joe2Laptop>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012, Joe Perches wrote:

> On Tue, 2012-01-24 at 23:46 +0100, Jesper Juhl wrote:
> > This patch tries to bring drivers/staging/bcm/CmHost.c somewhat in
> > line with CodingStyle.
> 
> There are already a couple of CmHost patches waiting.
> 
Thank you for the heads-up Joe. I wasn't aware of that.
I just noticed a few mem leaks and wanted to fix them and then couldn't 
help myself doing the style cleanup first ;)


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

