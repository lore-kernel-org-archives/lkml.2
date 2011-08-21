Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab1HUJML (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 05:12:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57165 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1HUJMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 05:12:06 -0400
Date: Sun, 21 Aug 2011 11:12:00 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        arnd@arndb.de, oleg@redhat.com, lizf@cn.fujitsu.com,
        paul@paulmenage.org, Matt Helsley <matthltc@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [GIT PULL pm-next] freezer: fix various bugs and simplify
 implementation
Message-ID: <20110821091200.GB24151@htj.dyndns.org>
References: <20110820094434.GA24151@htj.dyndns.org>
 <201108201833.39089.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108201833.39089.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafafel.

On Sat, Aug 20, 2011 at 06:33:38PM +0200, Rafael J. Wysocki wrote:
> >   ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git freezer
> 
> Pulled and stored in the pm-freezer branch in my tree, and merged into
> the linux-next branch.

Cool.

> > FYI, this patchset will cause a conflict with s390 TIF flag fix patch.
> > The conflict is trivial and Stephen should be able to handle it
> > without any problem.  Also, I'm planning on doing some further work on
> > cgroup freezer and then will try to bridge it with job control.  If
> > that plan fans out, I might ask Oleg to pull from the pm tree.
> 
> I'm not sure if Linus likes it.  He generally doesn't want the trees
> that he pulls from to be entangled this way.

The job control portion has to go through Linus anyway, so let's see
how that flies.

> > This shouldn't matter too much either way but it *might* be a good idea to
> > keep this line of patches in a separate branch.
> 
> I'm going to keep it in the pm-freezer branch anyway (there may be patches
> on top of it, though)

Yeah, I'm pretty sure it will need some fix too.

Thanks.

-- 
tejun
