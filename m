Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab1CBTUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:20:31 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49103 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1CBTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:20:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C9/QwmohPV2JbKAX5UnszTZFIkc//BMot+C8B1rrGR4EBM1lwPJP88X37G9PMI6gAR
         wEEdn+CfZvM2gdtR+EZ8Q0y6Ttar9eZ0/bbOnPJWSMSR4uWAmlhHEkbrx7JSbBjeN5t3
         xgoT7BBmfTLRY9d5qiz48YgRsLNRvWJzmhnyM=
Date: Wed, 2 Mar 2011 20:20:23 +0100
From: Roel Van Nyen <roel.vannyen@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        acho@novell.com
Subject: Re: [PATCH] Staging: keucr: Remove all type defines
Message-ID: <20110302192023.GA2112@roel-laptop>
References: <1299007790-5315-1-git-send-email-roel.vannyen@gmail.com>
 <20110301200006.GX18043@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301200006.GX18043@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 11:00:06PM +0300, Dan Carpenter wrote:
> On Tue, Mar 01, 2011 at 08:29:50PM +0100, Roel Van Nyen wrote:
> > Remove all type defines from driver and replace them with kernel built-in types.
> > 
> > Signed-off-by: Roel Van Nyen <roel.vannyen@gmail.com>
> 
> Some of your other patches were merged so this doesn't apply to
> linux-next any more.

Indeed, I should have made a patch-set instead.

> 
> > -typedef u8 BOOLEAN;
> 
> It might be better to use bool type or int for boolean variables.  But
> that can't be done automatically, it has to be audited carefully.  I
> don't feel strongly about this, I'm just throwing it out there as food
> for thought.  You are using the remove-typedef program btw?

I did not use the remove-typedef program, I used perl regex. (btw: where is that, i could not find it)
I will post a patchset later tonight wich contains the removal of all the types from this driver.
The first patch will contain the removal of all types except the BOOLEAN.
In the second one I will remove the boolean and check where to make it an integer and where a bool.

thanks,
roel
