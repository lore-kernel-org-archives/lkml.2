Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab0KGXqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:46:16 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26150 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab0KGXqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:46:15 -0500
Date: Mon, 8 Nov 2010 00:34:56 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Frank Mori Hess <fmhess@users.sourceforge.net>
cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Gustavo Silva <silvagustavo@users.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Arun Thomas <arun.thomas@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Chris R. Baugher" <baugher@enteract.com>,
        "David A. Schleef" <ds@schleef.org>
Subject: Re: [PATCH] staging, comedi, das16: das16_attach() needs to free
 allocated resources on failure
In-Reply-To: <201011071835.28692.fmhess@speakeasy.net>
Message-ID: <alpine.LNX.2.00.1011080034160.26247@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011072126150.26247@swampdragon.chaosbits.net> <201011071835.28692.fmhess@speakeasy.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Frank Mori Hess wrote:

> On Sunday 07 November 2010, Jesper Juhl wrote:
> > Hi,
> >
> > In drivers/staging/comedi/drivers/das16.c::das16_attach() there are many
> > potential failure scenarios. However, the driver neglects to free
> > resources it has allocated if failures happen.
> 
> This patch appears to be wrong.  The driver's detach function will be 
> called by the core if the attach function returns with an error.  The 
> resources are freed there.
> 
Ohh, sorry, I did not realize that.
In that case, please disregard this patch.
 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

