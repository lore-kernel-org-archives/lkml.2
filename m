Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab0JaGcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 02:32:11 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:16547 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412Ab0JaGcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 02:32:09 -0400
Date: Sun, 31 Oct 2010 07:21:48 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        Stephen Hemminger <shemminger@vyatta.com>, ulia Lawall <julia@diku.dk>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] SELinux: Do not assign the same value twice to the same
 variable
In-Reply-To: <1288495964.3017.37.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1010310717200.17199@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1010302306230.1572@swampdragon.chaosbits.net> <1288495964.3017.37.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Oct 2010, Eric Paris wrote:

> On Sat, 2010-10-30 at 23:10 +0200, Jesper Juhl wrote:
> > Hi,
> > 
> > It makes little sense to assign the same value to the same variable twice 
> > when there is no code inbetween which could have changed the value of that 
> > variable.
> 
> I don't like the patch.  The compiler will optimize it away (actually it
> will optimize both of them away) and it make it clear that if a new
> block is added in the middle that error codes can't be wrong....
> 
> It's just a personal preference I guess, but I like always setting the
> error code before goto outs.  Is there a reason doing this is a problem?
> 
It's not a problem as such, it just seemed a silly thing to do when I came 
across it. But, I can see your point in leaving it, so just forget about 
the patch.

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

