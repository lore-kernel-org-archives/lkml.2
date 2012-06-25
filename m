Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab2FYGbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:31:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18098 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab2FYGbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:31:05 -0400
Date: Mon, 25 Jun 2012 09:30:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Marcos Paulo de Souza <marcos.mage@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: Style cleanup of iwctl
Message-ID: <20120625063041.GL5390@mwanda>
References: <alpine.LNX.2.00.1206242131040.30361@swampdragon.chaosbits.net>
 <20120624204711.GK5390@mwanda>
 <alpine.LNX.2.00.1206242258230.30361@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1206242258230.30361@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 11:01:58PM +0200, Jesper Juhl wrote:
> On Sun, 24 Jun 2012, Dan Carpenter wrote:
> > Nope.  It is worth it.  Broken out patches are a million times
> > easier to review.
> > 
> Ok. I'll redo it as a series. It'll take a little while, so I may not 
> finish it tonight, but I'll do it.
> 

Thank you for redoing the new broken out version is a lot easier to
review.  For many of the patches, I just press my "filter white
space changes" button and the patch shows up as empty.  This process
takes me under five seconds.  But when it's all tangled up that
change could take minutes to untangle and verify.

> > It frustrates me that you would do things like this when you know
> > the rules.  Which part is difficult to understand?
> > 
> Nothing is difficult to understand, but breaking this into (for example) a 
> series that does:
> 	1) fix the indentation to use tabs and not spaces and proper depth
> 	2) remove space between cast and variable
> 	3) add spaces around operators (like "foo && bar" rather than "foo&&bar")
> 	4) add {} to all branches of if statement if one needs it (or remove if none need them)
> would, for many lines, result in all 4 patches changing the same lines.
> That just seemed like a little too much churn for a trivial style cleanup 
> patch.

How do I know if it's trivial or not when I can't review it
properly?  I think you are saying I should just trust you?  That's
not how it works at all.

regards,
dan carpenter
