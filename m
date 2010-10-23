Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068Ab0JWADI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 20:03:08 -0400
Received: from xenotime.net ([72.52.115.56]:58984 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754850Ab0JWADG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 20:03:06 -0400
Date: Fri, 22 Oct 2010 17:02:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dave@gnu.org, Dave Airlie <airlied@redhat.com>,
        Dave Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH RESEND] drm: include missing types header to drm_mode.h
Message-Id: <20101022170255.7feab5de.rdunlap@xenotime.net>
In-Reply-To: <20101022165517.effde8fb.akpm@linux-foundation.org>
References: <1287753199.2122.0.camel@cowboy>
	<20101022165517.effde8fb.akpm@linux-foundation.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 16:55:17 -0700 Andrew Morton wrote:

> On Fri, 22 Oct 2010 10:13:19 -0300
> Davidlohr Bueso <dave@gnu.org> wrote:
> 
> > drm: include missing types header to drm_mode.h
> > 
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > ---
> >  include/drm/drm_mode.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
> > index 0fc7397..eddd7f4 100644
> > --- a/include/drm/drm_mode.h
> > +++ b/include/drm/drm_mode.h
> > @@ -24,6 +24,8 @@
> >   * IN THE SOFTWARE.
> >   */
> >  
> > +#include <linux/types.h>
> > +
> >  #ifndef _DRM_MODE_H
> >  #define _DRM_MODE_H
> >  
> 
> Does this fix a build error?  If so, please send along the compiler
> error output.


Every build that has CONFIG_HEADERS_CHECK=y reports the following:

linux-next-20101022/X64/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-next-20101022/X64/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-next-20101022/X64/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-next-20101022/X64/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-next-20101022/X64/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-next-20101022/X64/usr/include/scsi/scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>
linux-next-20101022/X64/usr/include/linux/resource.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
