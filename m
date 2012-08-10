Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759112Ab2HJVna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 17:43:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab2HJVn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:43:26 -0400
Date: Fri, 10 Aug 2012 22:43:18 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, steveamigauk@yahoo.co.uk,
        mszeredi@suse.cz
Subject: Re: [PATCH 0/4] vfs: fix file creation mode bugs
Message-ID: <20120810214318.GA4284@rhmail.home.annexia.org>
References: <1344343549-11887-1-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344343549-11887-1-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 02:45:45PM +0200, Miklos Szeredi wrote:
> Al,
> 
> Please consider the following patches.
> 
> The first one fixes an old bug (stable CC-d).  The others are fixes for the
> atomic-open series.
> 
> Thanks,
> Miklos
> ----
> 
> Miklos Szeredi (4):
>       vfs: canonicalize create mode in build_open_flags()
>       vfs: atomic_open(): fix create mode usage
>       vfs: pass right create mode to may_o_create()
>       fuse: check create mode in atomic open
> 
> ---
>  fs/fuse/dir.c |    3 +++
>  fs/namei.c    |    4 ++--
>  fs/open.c     |    7 ++++---
>  3 files changed, 9 insertions(+), 5 deletions(-)

I added these four patches to the Fedora Rawhide kernel and these
fix the problems with ntfs-3g and my FUSE module.

Tested-by: Richard W.M. Jones <rjones@redhat.com>

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
