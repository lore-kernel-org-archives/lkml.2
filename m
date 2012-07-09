Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751056Ab2GIRW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 13:22:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52415 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2GIRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 13:22:25 -0400
Date: Mon, 9 Jul 2012 10:22:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        Hugh Dickins <hughd@google.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 2/3] cgroup: revise how we re-populate root directory
Message-ID: <20120709172220.GE1341@google.com>
References: <20120702142925.795007114@napanee.usersys.redhat.com>
 <20120702142926.405632285@napanee.usersys.redhat.com>
 <20120709171748.GD1341@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709171748.GD1341@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 10:17:48AM -0700, Tejun Heo wrote:
> On Mon, Jul 02, 2012 at 10:29:27AM -0400, Aristeu Rozanski wrote:
> > From: Li Zefan <lizefan@huawei.com>
> > 
> > When remounting cgroupfs with some subsystems added to it and some
> > removed, cgroup will remove all the files in root directory and then
> > re-popluate it.
> > 
> > What I'm doing here is, only remove files which belong to subsystems that
> > are to be unbinded, and only create files for newly-added subsystems.
> > The purpose is to have all other files untouched.
> > 
> > This is a preparation for cgroup xattr support.
> > 
> > v3:
> > - refresh patches after recent refactoring
> 
> Changing subsys_bits via remount is being deprecated.  No need to
> worry about this.

Also, why does this matter?  The xattrs are kept in cgrp anyway.  Why
does keeping dentry/inode around make difference?

Thanks.

-- 
tejun
