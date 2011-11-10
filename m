Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1KJVvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:51:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab1KJVvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:51:43 -0500
Date: Thu, 10 Nov 2011 13:51:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: David Rientjes <rientjes@google.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Hugh Dickins <hughd@chromium.org>, Hugh Dickins <hughd@google.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: avoid switching to text console if there is no
 panic timeout
Message-Id: <20111110135141.5fc6ea36.akpm@linux-foundation.org>
In-Reply-To: <20111110211504.GK8333@google.com>
References: <1318896400-32498-1-git-send-email-msb@chromium.org>
	<alpine.DEB.2.00.1110171727300.13515@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111101246560.21036@chino.kir.corp.google.com>
	<20111110211504.GK8333@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011 13:15:04 -0800
Mandeep Singh Baines <msb@chromium.org> wrote:

> David Rientjes (rientjes@google.com) wrote:
> > On Mon, 17 Oct 2011, David Rientjes wrote:
> > 
> > > On Mon, 17 Oct 2011, Mandeep Singh Baines wrote:
> > > 
> > > > From: Hugh Dickins <hughd@chromium.org>
> > > > 
> > > > Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
> > > > we're going to reboot immediately, the user will not be able to see the
> > > > messages anyway, and messing with the video mode may display artifacts,
> > > > and certainly get into several layers of complexity (including mutexes and
> > > > memory allocations) which we shall be much safer to avoid.
> > > > 
> > > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > > > [ Edited commit message and modified to short-circuit panic_timeout < 0
> > > >   instead of testing panic_timeout >= 0.  -Mandeep ]
> > > > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > > > Cc: Dave Airlie <airlied@redhat.com>
> > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > Cc: dri-devel@lists.freedesktop.org
> > > 
> > > Acked-by: David Rientjes <rientjes@google.com>
> > > 
> > 
> > Dave, where do we stand on this?  I haven't seen it hit Linus' tree and I 
> > don't see it in git://people.freedesktop.org/~airlied/linux.
> 
> The last status I have is Andrew pulling it into mmotm on 10/18/11.
> 
> Subject: + drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch added to -mm tree
> From: akpm@linux-foundation.org
> Date: Tue, 18 Oct 2011 15:42:46 -0700
> 
> 
> The patch titled
>      Subject: drm: avoid switching to text console if there is no panic timeout
> has been added to the -mm tree.  Its filename is
>      drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch

I need to do another round of sending patches to maintainers.

It's a depressing exercise because the great majority of patches are
simply ignored.  Last time I even added "please don't ignore" to the
email Subject: on the more important ones.  Sigh.

> Where is mmotm hosted these days?

On my disk, until kernel.org ftp access returns.

But I regularly email tarballs to Stephen, so it's all in linux-next. 
The mmotm tree is largely unneeded now - use linux-next to get at -mm
patches.

