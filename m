Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab2BXW5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:57:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35346 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094Ab2BXW5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:57:35 -0500
Date: Fri, 24 Feb 2012 23:56:29 +0100
From: Michal Marek <mmarek@suse.cz>
To: Mattia Dongili <malattia@linux.it>
Cc: Ben Hutchings <ben@decadent.org.uk>, Joerg Roedel <joerg.roedel@amd.com>,
        linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>,
        debian-kernel@lists.debian.org, linux-kbuild@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] kbuild: Only build linux-image package for UML
Message-ID: <20120224225629.GB19992@sepie.suse.cz>
References: <1329323907-7696-1-git-send-email-joerg.roedel@amd.com>
 <1329323907-7696-2-git-send-email-joerg.roedel@amd.com>
 <1329367790.3048.168.camel@deadeye>
 <20120216212926.GA8970@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216212926.GA8970@kamineko.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 06:29:27AM +0900, Mattia Dongili wrote:
> On Thu, Feb 16, 2012 at 04:49:50AM +0000, Ben Hutchings wrote:
> > On Wed, 2012-02-15 at 17:38 +0100, Joerg Roedel wrote:
> > > For user-mode Linux the other packages are not required. So
> > > only build the package with the linux-image in it.
> > > 
> > > Cc: Michal Marek <mmarek@suse.cz>
> > > Cc: maximilian attems <max@stro.at>
> > > Cc: Ben Hutchings <ben@decadent.org.uk>
> > > Cc: debian-kernel@lists.debian.org
> > > Cc: linux-kbuild@vger.kernel.org
> > > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> > Tested-by: Ben Hutchings <ben@decadent.org.uk>
> > 
> > But I've never touched UML either so we should get confirmation that
> > this really is the right thing to do.
> 
> there is a wishlist bug opened ages ago (and pinged not so long ago)
> requesting headers to be packaged in debian:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=186930
> Just to say that there is some interest in having headers packaged
> somehow.

As there was no further reaction, I applied the patch now to
kbuild.git#misc.

Michal
