Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab0KLCzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 21:55:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:38899 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754354Ab0KLCzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 21:55:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,186,1288594800"; 
   d="scan'208";a="347769565"
Subject: Re: [PATCH] acpi: Provide decls for standalone compilation of
 video.h without ACPI (v2)
From: Zhang Rui <rui.zhang@intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, "Brown, Len" <len.brown@intel.com>
In-Reply-To: <1289524357.8148.1396.camel@rui>
References: <1283693757-8199-1-git-send-email-chris@chris-wilson.co.uk>
	 <1283694709-8504-1-git-send-email-chris@chris-wilson.co.uk>
	 <1289524357.8148.1396.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 10:57:02 +0800
Message-ID: <1289530622.8148.1500.camel@rui>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 09:12 +0800, Zhang Rui wrote:
> On Sun, 2010-09-05 at 21:51 +0800, Chris Wilson wrote:
> > Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> > Cc: Matthew Garrett <mjg@redhat.com>
> > Cc: Zhang Rui <rui.zhang@intel.com>
> > Cc: Len Brown <len.brown@intel.com>
> 
> Acked-by: Zhang Rui <rui.zhang@intel.com>
> 
> > ---
> >  include/acpi/video.h |    5 ++++-
> >  1 files changed, 4 insertions(+), 1 deletions(-)
> > 
> > diff --git a/include/acpi/video.h b/include/acpi/video.h
> > index 551793c..0e98e67 100644
> > --- a/include/acpi/video.h
> > +++ b/include/acpi/video.h
> > @@ -1,6 +1,10 @@
> >  #ifndef __ACPI_VIDEO_H
> >  #define __ACPI_VIDEO_H
> >  
> > +#include <linux/errno.h> /* for ENODEV */
> > +
> > +struct acpi_device;
> > +
Oh, btw, this line is actually not needed,
because acpi_video_get_edid is not invoked in any place when CONFIG_ACPI
is cleared.

> >  #define ACPI_VIDEO_DISPLAY_CRT  1
> >  #define ACPI_VIDEO_DISPLAY_TV   2
> >  #define ACPI_VIDEO_DISPLAY_DVI  3
> > @@ -26,4 +30,3 @@ static inline int acpi_video_get_edid(struct acpi_device *device, int type,
> >  #endif
> >  
> >  #endif
> > -
> 


