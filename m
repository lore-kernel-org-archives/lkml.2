Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab2GGAaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 20:30:00 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:17096 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755676Ab2GGA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 20:29:59 -0400
Date: Sat, 7 Jul 2012 02:29:57 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, Marcos Paulo de Souza <marcos.mage@gmail.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6656: iwctl: mop up a few remaining obvious
 style issues
In-Reply-To: <20120706230945.GA8835@kroah.com>
Message-ID: <alpine.LNX.2.00.1207070228340.13344@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1206272116490.6908@swampdragon.chaosbits.net> <20120706230945.GA8835@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Greg Kroah-Hartman wrote:

> On Wed, Jun 27, 2012 at 09:19:15PM +0200, Jesper Juhl wrote:
> > My previous 14 patch series to vt6656 missed a few bits and
> > pieces. This mops up the last few obvious style issues.
> > It is quite short and completely trivial - simply deletes a few blank
> > lines, does some whitespace cleanup around operators and adds a few
> > curly braces.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> 
> Again, one patch per thing please.  Please break this up into different
> patches so it can be accepted.
> 
Ok, ok :-)
I really thought that this one was so short and trivial that it would be 
OK - but I'll break it up and submit a tiny series against linux-next some 
time during the weekend (as a reply to this mail).

> greg k-h
> 

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

