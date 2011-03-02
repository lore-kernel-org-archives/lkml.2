Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab1CBTiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:38:04 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54142 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1CBTiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:38:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WKQ+wt0e88/2ASjOH2sWLA07HyY19LW0YyqrqGi2d3hClpp5+ShypbjqA4jJHd7tyn
         g8B9XvwqGS/XGSPvRSQND4sIV+nzCF9IvxoMgkBMLvo1Q6KgY7oyjDFfvbMYPWqDzCrQ
         NBltaejK99DhJ1yh9CeL9nqAy9y5N/vuhm9cc=
Date: Wed, 2 Mar 2011 22:37:41 +0300
From: Dan Carpenter <error27@gmail.com>
To: Roel Van Nyen <roel.vannyen@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        acho@novell.com
Subject: Re: [PATCH] Staging: keucr: Remove all type defines
Message-ID: <20110302193741.GO18043@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Roel Van Nyen <roel.vannyen@gmail.com>, gregkh@suse.de,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	acho@novell.com
References: <1299007790-5315-1-git-send-email-roel.vannyen@gmail.com>
 <20110301200006.GX18043@bicker>
 <20110302192023.GA2112@roel-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302192023.GA2112@roel-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 02, 2011 at 08:20:23PM +0100, Roel Van Nyen wrote:
> On Tue, Mar 01, 2011 at 11:00:06PM +0300, Dan Carpenter wrote:
> > On Tue, Mar 01, 2011 at 08:29:50PM +0100, Roel Van Nyen wrote:
> > > -typedef u8 BOOLEAN;
> > 
> > It might be better to use bool type or int for boolean variables.  But
> > that can't be done automatically, it has to be audited carefully.  I
> > don't feel strongly about this, I'm just throwing it out there as food
> > for thought.  You are using the remove-typedef program btw?
> 
> I did not use the remove-typedef program, I used perl regex. (btw: where is that, i could not find it)

I just saw Luis R. Rodriguez mention it.  I hadn't heard of it before.

http://www.kernel.org/pub/linux/kernel/people/mcgrof/scripts/remove-typedef

> I will post a patchset later tonight wich contains the removal of all the types from this driver.
> The first patch will contain the removal of all types except the BOOLEAN.
> In the second one I will remove the boolean and check where to make it an integer and where a bool.

Sounds good.

regards,
dan carpenter

