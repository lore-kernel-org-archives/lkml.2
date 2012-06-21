Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798Ab2FUX3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:29:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886Ab2FUX3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:29:46 -0400
Date: Fri, 22 Jun 2012 01:29:44 +0200
From: Jan Kara <jack@suse.cz>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Jan Kara <jack@suse.cz>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] udf: stop using s_dirt
Message-ID: <20120621232944.GB11645@quack.suse.cz>
References: <1338810384-26437-1-git-send-email-dedekind1@gmail.com>
 <20120604134409.GB11010@quack.suse.cz>
 <1340281963.13910.213.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340281963.13910.213.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 21-06-12 15:32:43, Artem Bityutskiy wrote:
> On Mon, 2012-06-04 at 15:44 +0200, Jan Kara wrote:
> > On Mon 04-06-12 14:46:24, Artem Bityutskiy wrote:
> > > From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> > > 
> > > The UDF file-system does not need the 's_dirt' superblock flag because it does
> > > not define the 'write_super()' method. This flag was set to 1 in few places and
> > > set to 0 in '->sync_fs()' and was basically useless. Stop using it because it
> > > is on its way out.
> >   Thanks. I've merged the patch to my tree.
> 
> Sorry Jan, but which one? I do not see it here at least:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
> 
> [I am trying to find out which bits and pieces of this work are where]
  Currently it's in for_testing branch. I've pushed the tree so that you
can see it as well ;).

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
