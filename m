Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab1LNRp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:45:29 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48537 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab1LNRp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:45:27 -0500
Date: Wed, 14 Dec 2011 12:39:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] modpost: add option to allow external modules to avoid
 taint
Message-ID: <20111214173922.GA2607@tuxdriver.com>
References: <1323752547.2825.101.camel@deadeye>
 <1323879603-2961-1-git-send-email-linville@tuxdriver.com>
 <1323881520.2825.196.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323881520.2825.196.camel@deadeye>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 04:52:00PM +0000, Ben Hutchings wrote:
> On Wed, 2011-12-14 at 11:20 -0500, John W. Linville wrote:
> > In some cases, it might be desirable to package a module from an
> > external source tree alongside the base kernel.  In those cases, it
> > might also be desirable to not have those modules tainting the kernel.
> > 
> > This patch provides a mechanism for an external module build to declare
> > itself as an "integrated build".  Such a module is then treated the same
> > as an intree module.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> > Any thoughts on this?  I'm thinking of adding this to Fedora kernels,
> > where I have been working to integrate the compat-wireless package as
> > part of the base kernel RPM.
> [...]
> 
> If you're integrating it then why can't you *really* build it in-tree?

Well, of course, I could.  But it would be a _huge_ waste of my time
doing so.  The compat-wireless package is already sitting there,
complete with all the necessary backporting infrastructure.  It's all
fat and juicy, waiting to be used.  Wasting time replicating that
just doesn't make any sense to my mind.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
