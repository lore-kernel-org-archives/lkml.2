Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab1KJVPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:15:46 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60099 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1KJVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:15:43 -0500
Date: Thu, 10 Nov 2011 13:15:04 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Hugh Dickins <hughd@chromium.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: avoid switching to text console if there is no
 panic timeout
Message-ID: <20111110211504.GK8333@google.com>
References: <1318896400-32498-1-git-send-email-msb@chromium.org>
 <alpine.DEB.2.00.1110171727300.13515@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1111101246560.21036@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111101246560.21036@chino.kir.corp.google.com>
X-Operating-System: Linux/2.6.38.8-gg621 (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes (rientjes@google.com) wrote:
> On Mon, 17 Oct 2011, David Rientjes wrote:
> 
> > On Mon, 17 Oct 2011, Mandeep Singh Baines wrote:
> > 
> > > From: Hugh Dickins <hughd@chromium.org>
> > > 
> > > Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
> > > we're going to reboot immediately, the user will not be able to see the
> > > messages anyway, and messing with the video mode may display artifacts,
> > > and certainly get into several layers of complexity (including mutexes and
> > > memory allocations) which we shall be much safer to avoid.
> > > 
> > > Signed-off-by: Hugh Dickins <hughd@google.com>
> > > [ Edited commit message and modified to short-circuit panic_timeout < 0
> > >   instead of testing panic_timeout >= 0.  -Mandeep ]
> > > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > > Cc: Dave Airlie <airlied@redhat.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: dri-devel@lists.freedesktop.org
> > 
> > Acked-by: David Rientjes <rientjes@google.com>
> > 
> 
> Dave, where do we stand on this?  I haven't seen it hit Linus' tree and I 
> don't see it in git://people.freedesktop.org/~airlied/linux.

The last status I have is Andrew pulling it into mmotm on 10/18/11.

Subject: + drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch added to -mm tree
From: akpm@linux-foundation.org
Date: Tue, 18 Oct 2011 15:42:46 -0700


The patch titled
     Subject: drm: avoid switching to text console if there is no panic timeout
has been added to the -mm tree.  Its filename is
     drm-avoid-switching-to-text-console-if-there-is-no-panic-timeout.patch

Where is mmotm hosted these days?

Regards,
Mandeep
