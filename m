Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab2ISQDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 12:03:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:3655 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932287Ab2ISQDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 12:03:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,447,1344236400"; 
   d="scan'208";a="194899713"
Date: Wed, 19 Sep 2012 18:03:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de
Subject: Re: [rtc-linux] [PATCH 1/1] drivers/rtc/rtc-ab8500.c: Revoke Device
 Tree enablement
Message-ID: <20120919160302.GN28670@sortiz-mobl>
References: <1344527828-6283-1-git-send-email-lee.jones@linaro.org>
 <1344527828-6283-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdZa-72QogrZ-P5jbDHTTX64babZo3ydjzfgC-4LWUBfMg@mail.gmail.com>
 <20120831110818.GA5962@gmail.com>
 <CACRpkdat3zj_47r7ENz7Qv3N8cNOSKDV+k5em9DjOhkNycy9gQ@mail.gmail.com>
 <CACRpkdbXwLXoWL+PS-wJ9cbztC-jWhyc=vr+98ffg70f6coaiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbXwLXoWL+PS-wJ9cbztC-jWhyc=vr+98ffg70f6coaiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, Sep 01, 2012 at 01:28:34AM +0200, Linus Walleij wrote:
> On Sat, Sep 1, 2012 at 1:27 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Fri, Aug 31, 2012 at 1:08 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >> On Tue, Aug 14, 2012 at 10:32:02AM +0200, Linus Walleij wrote:
> >>> On Thu, Aug 9, 2012 at 5:57 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >>>
> >>> > All AB8500 devices are now registered via MFD core, so Device Tree
> >>> > capability is no longer required for probing. Here we pull the DT
> >>> > match table to ensure we're no longer probed during Device Tree
> >>> > start-up.
> >>> >
> >>> > CC: Alessandro Zummo <a.zummo@towertech.it>
> >>> > CC: rtc-linux@googlegroups.com
> >>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>>
> >>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >>
> >> I'm guessing we still need Alessandro's Ack?
> >
> > Well, usually we have Andrew Morton merging patches for RTC, so
> > put him on CC.
> >
> > If I was the MFD maintainer I'd just merge this though, it's quite
> > obvious.
> >
> > Sam: do you agree?
I'd love to see the patch first :)
Could you please bounce it to me ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
