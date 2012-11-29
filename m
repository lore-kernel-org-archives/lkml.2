Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2K2WbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:31:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab2K2WbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:31:16 -0500
Date: Thu, 29 Nov 2012 17:31:11 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Message-ID: <20121129223111.GZ32112@redhat.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
 <20121129195942.GW32112@redhat.com>
 <20121129202608.GA26716@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129202608.GA26716@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 08:26:08PM +0000, Serge E. Hallyn wrote:
> Quoting Aristeu Rozanski (aris@redhat.com):
> > I see your point. it's indeed a problem. in dev_exception_add(), it
> > needs to check for permissions before actually adding to
> > devcgroup->exceptions.

actually, checked again, it's done correctly. when adding an exception
that will allow extra device access (DEVCG_ALLOW), it does check it
before. It means that you can't add local exceptions unless at a certain
point of the time it was allowed to do so.

> > 
> > > (Btw is there a git tree or gitweb view I could look at alongside
> > > the patchset?)
> > 
> > I'll rebase the patchset along with a fix for this and resubmit with a
> > link to the git repo.

just pushed the same version to:
git://github.com/aristeu/linux-2.6.git

please use branch devcg_hiearchy_review

-- 
Aristeu

