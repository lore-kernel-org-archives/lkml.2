Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328Ab2HNT7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 15:59:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448Ab2HNT7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 15:59:15 -0400
Message-ID: <1344974352.4683.320.camel@ul30vt.home>
Subject: Re: [GIT PULL] VFIO update for 3.6-rc1
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Date: Tue, 14 Aug 2012 13:59:12 -0600
In-Reply-To: <1344366349.3441.86.camel@ul30vt.home>
References: <1344366349.3441.86.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 13:05 -0600, Alex Williamson wrote:
> Hi Linus,
> 
> The following changes since commit 42a579a0f960081cd16fc945036e4780c3ad3202:
> 
>   Merge branches 'timers-urgent-for-linus' and 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-08-05 22:28:49 +0300)
> 
> are available in the git repository at:
> 
> 
>   git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.6-rc1
> 
> for you to fetch changes up to 817fea2df3c24b22f6123dc0106eb063b7132883:
> 
>   vfio: Include vfio.h in installed headers (2012-08-07 11:48:33 -0600)
> 
> ----------------------------------------------------------------
> VFIO for v3.6-rc1
> 
> Just a trivial patch to include vfio.h in the installed headers
> so we can complete userspace integration into QEMU.  Thanks!
> 
> ----------------------------------------------------------------
> Alex Williamson (1):
>       vfio: Include vfio.h in installed headers
> 
>  include/linux/Kbuild | 1 +
>  1 file changed, 1 insertion(+)
> 

Hi Linus,

I'd really appreciate getting this fix in, I can send as a patch if you
prefer for such a trivial change.  Thanks,

Alex

