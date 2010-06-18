Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab0FRFZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 01:25:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58601 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab0FRFZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 01:25:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nOY4u54plfZMEOIw/+jZY6m1p6nKwgANp/OzdRZsCdoeYVc4mm6pi+17nJSp3VsHbT
         p7Cs6lBX5r+EiexKeJDezBDhDpmqDD1N35LSQDznA0dwUPbO6GqV1P0h94e0YsIaQlNv
         UVbGjHXhvZolDPWxY1RIiDsNgtOUh50pqtoFs=
Date: Thu, 17 Jun 2010 22:25:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
       Greg Thelen <gthelen@google.com>,
       Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
Message-ID: <20100618052459.GA15993@core.coreip.homeip.net>
References: <4C1764CD.3080402@suse.cz>
 <1276782038-23441-1-git-send-email-mmarek@suse.cz>
 <alpine.DEB.2.00.1006171603520.622@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1006171603520.622@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 04:05:05PM -0700, David Rientjes wrote:
> On Thu, 17 Jun 2010, Michal Marek wrote:
> 
> > Now that we run scripts/setlocalversion during every build, it makes
> > sense to move all the localversion logic there. This cleans up the
> > toplevel Makefile and also makes sure that the script is called only
> > once in 'make prepare' (previously, it would be called every time due to
> > a variable expansion in an ifneq statement). No user-visible change is
> > intended, unless one runs the setlocalversion script directly.
> > 
> > Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Greg Thelen <gthelen@google.com>
> > Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
> > Signed-off-by: Michal Marek <mmarek@suse.cz>
> > ---
> > 
> > I tried to test this in various scenarios, but if anyone of you could give
> > it a try, that would be great. The patch is against 2.6.35-rc3.
> > 
> 
> I agree it would be better to move this to scripts/setlocalversion, thanks 
> for looking into it.  I'll put this into my build cycles and see if it 
> causes any issues in my workflow that is known to be good with 2.6.35-rc3.  
> Since this is 2.6.36 material, it seems like we have some time.

No, I am sorry, it is not .36 material as the building on remote box was
messed up in .35 cycle.

-- 
Dmitry
