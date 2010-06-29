Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab0F2Vyb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:54:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40665 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0F2Vy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dj36JLr7VO/Yvl6XyevULPRLsZA4U12U/8o0EvBZqDecOAxxrb/xKPqgfCMTtJ7tcw
         SpI5YYJYmIaq+yI95HrOpu5221W5DB8gtdUqr82jaw/zKy3d9kOa110Xpbxmf5BNZs4b
         mZF/Sko2GX1JBwy8LkZKI68RmrPihh2sws27w=
Date: Tue, 29 Jun 2010 14:54:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Greg Thelen <gthelen@google.com>,
       Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
Message-ID: <20100629215421.GA24113@core.coreip.homeip.net>
References: <4C1764CD.3080402@suse.cz>
 <1276782038-23441-1-git-send-email-mmarek@suse.cz>
 <20100618055512.GA20186@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100618055512.GA20186@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:55:12PM -0700, Dmitry Torokhov wrote:
> On Thu, Jun 17, 2010 at 03:40:38PM +0200, Michal Marek wrote:
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
> Seems to be working for me, I do not need to go and fetch coffee while
> installig newly compiled kernel anymore.
> 

Michal,

Any chance this could be merged in 2.6.35? Without the patch installing
over the network is not really an option anymore.

Thanks.

-- 
Dmitry
