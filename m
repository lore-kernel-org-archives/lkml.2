Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113Ab1KJUuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 15:50:12 -0500
Received: from mail-dy0-f46.google.com ([209.85.220.46]:63075 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab1KJUuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 15:50:08 -0500
Date: Thu, 10 Nov 2011 12:50:01 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mandeep Singh Baines <msb@chromium.org>, Dave Airlie <airlied@redhat.com>
cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Hugh Dickins <hughd@chromium.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: avoid switching to text console if there is no
 panic timeout
In-Reply-To: <alpine.DEB.2.00.1110171727300.13515@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1111101246560.21036@chino.kir.corp.google.com>
References: <1318896400-32498-1-git-send-email-msb@chromium.org> <alpine.DEB.2.00.1110171727300.13515@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, David Rientjes wrote:

> On Mon, 17 Oct 2011, Mandeep Singh Baines wrote:
> 
> > From: Hugh Dickins <hughd@chromium.org>
> > 
> > Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
> > we're going to reboot immediately, the user will not be able to see the
> > messages anyway, and messing with the video mode may display artifacts,
> > and certainly get into several layers of complexity (including mutexes and
> > memory allocations) which we shall be much safer to avoid.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > [ Edited commit message and modified to short-circuit panic_timeout < 0
> >   instead of testing panic_timeout >= 0.  -Mandeep ]
> > Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> > Cc: Dave Airlie <airlied@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: dri-devel@lists.freedesktop.org
> 
> Acked-by: David Rientjes <rientjes@google.com>
> 

Dave, where do we stand on this?  I haven't seen it hit Linus' tree and I 
don't see it in git://people.freedesktop.org/~airlied/linux.
