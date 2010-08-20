Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab0HTWYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:24:54 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:35463 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009Ab0HTWYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:24:52 -0400
Date: Fri, 20 Aug 2010 17:24:50 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Dustin Kirkland <kirkland@canonical.com>,
        ecryptfs-devel@lists.launchpad.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: properly mark init functions
Message-ID: <20100820222450.GA28193@boomer>
References: <4C6AA995.6040008@redhat.com>
 <20100819002836.GA8552@boomer>
 <4C6CEA20.5010802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6CEA20.5010802@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Aug 19, 2010 at 10:24:00AM +0200, Jerome Marchand <jmarchan@redhat.com> wrote:
> On 08/19/2010 02:28 AM, Tyler Hicks wrote:
> > On Tue Aug 17, 2010 at 05:24:05PM +0200, Jerome Marchand <jmarchan@redhat.com> wrote:
> >>
> >> Some ecryptfs init functions are not prefixed by __init and thus not
> >> freed after initialization. This patch saved about 1kB in ecryptfs
> >> module.
> >>
> >> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
> >> ---
> > 
> > Thanks Jerome - We could also get away with marking
> > ecryptfs_init_kmem_caches() and do_sysfs_registration() with __init,
> > right?
> > 
> > Tyler
> > 
> 
> I guess we could. But it doesn't really matter, these are static functions which
> are called from only one place, so they're inlined anyway. I don't know what the
> convention is in such case.
> 

Good point - this has been applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Thanks,
Tyler
