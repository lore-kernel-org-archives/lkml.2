Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0FRFzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 01:55:19 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:41273 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0FRFzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 01:55:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gbx0HN1LhM3AGABjksPyo8nlPQsM+U7NsTqxCYV4Ew7RpQAPEK5g495adV8MUdQxdb
         oDw5Hu9mja0SvDnbNHH5i2MDKXnkzvAQE2j8CTx+7+alBBwG136VammGo3N4BdE3XXDe
         QWa41a3hii656G1kNqBDbrjYcmPIMv4PNgWiI=
Date: Thu, 17 Jun 2010 22:55:12 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Greg Thelen <gthelen@google.com>,
       Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
Message-ID: <20100618055512.GA20186@core.coreip.homeip.net>
References: <4C1764CD.3080402@suse.cz>
 <1276782038-23441-1-git-send-email-mmarek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276782038-23441-1-git-send-email-mmarek@suse.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 03:40:38PM +0200, Michal Marek wrote:
> Now that we run scripts/setlocalversion during every build, it makes
> sense to move all the localversion logic there. This cleans up the
> toplevel Makefile and also makes sure that the script is called only
> once in 'make prepare' (previously, it would be called every time due to
> a variable expansion in an ifneq statement). No user-visible change is
> intended, unless one runs the setlocalversion script directly.
> 
> Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
> 
> I tried to test this in various scenarios, but if anyone of you could give
> it a try, that would be great. The patch is against 2.6.35-rc3.
> 

Seems to be working for me, I do not need to go and fetch coffee while
installig newly compiled kernel anymore.

Thanks for your help Michal.

-- 
Dmitry
