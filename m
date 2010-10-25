Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab0JYCN6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 22:13:58 -0400
Received: from mailbigip.dreamhost.com ([208.97.132.5]:51887 "EHLO
	homiemail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752143Ab0JYCN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 22:13:56 -0400
Subject: Re: [PATCH RESEND] drm: include missing types header to drm_mode.h
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
In-Reply-To: <20101022170255.7feab5de.rdunlap@xenotime.net>
References: <1287753199.2122.0.camel@cowboy>
	 <20101022165517.effde8fb.akpm@linux-foundation.org>
	 <20101022170255.7feab5de.rdunlap@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 24 Oct 2010 23:13:40 -0300
Message-ID: <1287972820.2047.0.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 17:02 -0700, Randy Dunlap wrote:
> On Fri, 22 Oct 2010 16:55:17 -0700 Andrew Morton wrote:
> 
> > On Fri, 22 Oct 2010 10:13:19 -0300
> > Davidlohr Bueso <dave@gnu.org> wrote:
> > 
> > > drm: include missing types header to drm_mode.h
> > > 
> > > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> > > ---
> > >  include/drm/drm_mode.h |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
> > > index 0fc7397..eddd7f4 100644
> > > --- a/include/drm/drm_mode.h
> > > +++ b/include/drm/drm_mode.h
> > > @@ -24,6 +24,8 @@
> > >   * IN THE SOFTWARE.
> > >   */
> > >  
> > > +#include <linux/types.h>
> > > +
> > >  #ifndef _DRM_MODE_H
> > >  #define _DRM_MODE_H
> > >  
> > 
> > Does this fix a build error?  If so, please send along the compiler
> > error output.
> 
> 
> Every build that has CONFIG_HEADERS_CHECK=y reports the following:
> 
> linux-next-20101022/X64/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/scsi/scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/linux/resource.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 

Yeah that's what made me send the patch.

Thanks,
Davidlohr

