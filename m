Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452Ab2BXW5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 17:57:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142Ab2BXW5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 17:57:35 -0500
Date: Fri, 24 Feb 2012 23:56:47 +0100
From: Michal Marek <mmarek@suse.cz>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        maximilian attems <max@stro.at>, debian-kernel@lists.debian.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] kbuild: Fix link to headers in 'make deb-pkg'
Message-ID: <20120224225647.GC19992@sepie.suse.cz>
References: <1329323907-7696-1-git-send-email-joerg.roedel@amd.com>
 <1329367521.3048.165.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329367521.3048.165.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 04:45:21AM +0000, Ben Hutchings wrote:
> On Wed, 2012-02-15 at 17:38 +0100, Joerg Roedel wrote:
> > The Link to the kernel header files in the debian packages
> > point to the original build directory. This is a bad choice
> > if the packages were installed on a different machine. Fix
> > this in by manually re-creating the link in the builddeb
> > script.
> > 
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: maximilian attems <max@stro.at>
> > Cc: Ben Hutchings <ben@decadent.org.uk>
> > Cc: debian-kernel@lists.debian.org
> > Cc: linux-kbuild@vger.kernel.org
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> [...]
> Reviewed-by: Ben Hutchings <ben@decadent.org.uk>

Applied to kbuild.git#misc.

Michal
