Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab0GCCAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 22:00:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0GCCAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 22:00:06 -0400
Date: Fri, 2 Jul 2010 18:55:06 -0700
From: Greg KH <gregkh@suse.de>
To: tytso@mit.edu, linux-kernel@vger.kernel.org, stable@kernel.org,
       stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: [patch 119/149] ext4: check s_log_groups_per_flex in online
 resize code
Message-ID: <20100703015506.GA16229@suse.de>
References: <20100701175144.GA2116@kroah.com>
 <20100701173216.846632087@clark.site>
 <20100702041102.GJ1333@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100702041102.GJ1333@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 12:11:02AM -0400, tytso@mit.edu wrote:
> On Thu, Jul 01, 2010 at 10:32:25AM -0700, Greg KH wrote:
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> My only objection to these patches is that I don't know if they are
> going to cause patch conflicts with the 50 or so patches which I sent
> you for 2.6.32, which include both this patch and the next one.  When
> I backported the patches I did have to adjust some of them to make
> sure they would apply cleanly to the latest 2.6.32.X release.  By
> cherry picking them, it could be that dropping those patches from
> could cause no problems at all; or it could be a bit of a headache.
> 
> So it might be easier to drop these two and then wait for the next
> 2.6.32 stable release (which will hopefully be coming soon!) and just
> take my whole set of patches....

Ok, I've now dropped them and will pick them up for the next release
with the full series that you have sent me.

thanks,

greg k-h
