Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab2IGPQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:16:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:45258 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2IGPQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:16:53 -0400
Date: Fri, 7 Sep 2012 08:16:48 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 12/15] firmware: introduce
 device_cache/uncache_fw_images
Message-ID: <20120907151648.GE7157@kroah.com>
References: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
 <1344052890-31935-13-git-send-email-ming.lei@canonical.com>
 <20120906154459.8b3b73fa.akpm@linux-foundation.org>
 <CACVXFVMD1MCGrmHLFU5whCf1R3feoyj+FTAMm71HNME_gF2jDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMD1MCGrmHLFU5whCf1R3feoyj+FTAMm71HNME_gF2jDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 11:32:36AM +0800, Ming Lei wrote:
> On Fri, Sep 7, 2012 at 6:44 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat,  4 Aug 2012 12:01:27 +0800
> > Ming Lei <ming.lei@canonical.com> wrote:
> >
> >> This patch introduces the three helpers below:
> >>
> >>       void device_cache_fw_images(void)
> >>       void device_uncache_fw_images(void)
> >>       void device_uncache_fw_images_delay(unsigned long)
> >
> > CONFIG_PM=n:
> >
> > drivers/base/firmware_class.c:1147: warning: 'device_cache_fw_images' defined but not used
> > drivers/base/firmware_class.c:1212: warning: 'device_uncache_fw_images_delay' defined but not used
> 
> Thanks for your report.
> 
> >
> > the fix is not trivial - this patch added quite a lot of code and data
> > structure bloat which will never be used on CONFIG_PM=n kernels.
> 
> The below patch should fix the warning.

Can you send it to me in a format that I can apply it in?

greg k-h
