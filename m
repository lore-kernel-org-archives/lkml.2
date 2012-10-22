Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2JVUOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 16:14:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40619 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2JVUOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 16:14:37 -0400
Date: Mon, 22 Oct 2012 16:14:22 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        James Morris <jmorris@namei.org>, Pavel Emelyanov <xemul@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, Jiri Slaby <jslaby@suse.cz>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 0/4] Rebase device_cgroup v2 patchset
Message-ID: <20121022201422.GA14085@redhat.com>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20121022125838.20cdc240.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022125838.20cdc240.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
On Mon, Oct 22, 2012 at 12:58:38PM -0700, Andrew Morton wrote:
> On Mon, 22 Oct 2012 09:45:36 -0400
> Aristeu Rozanski <aris@redhat.com> wrote:
> 
> > This patchset rebases the v2 of the patchset since the v1 was pushed into -rc1
> > instead. The last patch, not present on previous patchset, fixes the
> > permission check when allowing everything in a cgroup.
> > 
> 
> I grabbed all four, thanks.  Shall send them on to Linus in a week or
> so, after a bit more review and some linux-next testing.

thanks, much appreciated

> I've been trying to work out why I merged the v1 patchset rather than
> v2 and cannot find that v2 patchset anywhere.  When was it sent out?

It was sent to linux-kernel and cgroups@vger on Sep 04th, here's the
msgid of patch 0 for reference:
<20120904143419.892872876@napanee.usersys.redhat.com> 

-- 
Aristeu

