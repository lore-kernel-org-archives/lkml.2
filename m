Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0EFWfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 18:35:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39981 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab0EFWfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 18:35:21 -0400
Date: Thu, 6 May 2010 15:34:57 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oren Laadan <orenl@cs.columbia.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Pavel Emelyanov <xemul@openvz.org>,
       Cedric Le Goater <legoater@free.fr>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH v21 015/100] cgroup freezer: Update stale locking
 comments
Message-ID: <20100506223457.GN31830@count0.beaverton.ibm.com>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
 <1272723382-19470-16-git-send-email-orenl@cs.columbia.edu>
 <201005062140.19821.rjw@sisk.pl>
 <20100506203117.GM31830@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506203117.GM31830@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 01:31:17PM -0700, Matt Helsley wrote:
> On Thu, May 06, 2010 at 09:40:19PM +0200, Rafael J. Wysocki wrote:
> > On Saturday 01 May 2010, Oren Laadan wrote:
> > > From: Matt Helsley <matthltc@us.ibm.com>
> > > 
> > > Update stale comments regarding locking order and add a little more detail
> > > so it's easier to follow the locking between the cgroup freezer and the
> > > power management freezer code.
> > 
> > I guess these three patches are for me.
> > 
> > Do you want me to handle them?
> > 
> > Rafael
> 
> Hi Rafael,
> 
> 	I think you can take 15 as it's an update to the comments.
> 
> 16 and 17 are specific to checkpoint/restart. There are no other in-kernel
> uses, that we've identified, for them. So I was under the impression that it's
> inappropriate to add them without also adding the checkpoint/restart patches
> that use them.

Of course, assuming I'm wrong about the dependency on checkpoint/restart, I
have no objection to your taking them.

Thanks again!

Cheers,
	-Matt Helsley
