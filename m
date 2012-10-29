Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2J2HZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:25:26 -0400
Received: from eazy.amigager.de ([213.239.192.238]:37179 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2J2HZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:25:24 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2012 03:25:23 EDT
Date: Mon, 29 Oct 2012 08:17:15 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: Norbert Preining <preining@logic.at>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Dave Airlie <airlied@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: drm i915 hangs on heavy io load
Message-ID: <20121029071715.GA17023@mac.home>
Mail-Followup-To: Norbert Preining <preining@logic.at>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Dave Airlie <airlied@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
 <6c3329$6sai31@orsmga002.jf.intel.com>
 <20121023053830.GA30776@gamma.logic.tuwien.ac.at>
 <CAPM=9txr4TzuG-BbL0bXeEK6AzkOK9pH0kh-nP=Njv53sgFZew@mail.gmail.com>
 <20121024003659.GA30962@gamma.logic.tuwien.ac.at>
 <b94cdc$72fm1r@fmsmga001.fm.intel.com>
 <20121028024753.GA4254@gamma.logic.tuwien.ac.at>
 <eeac1e$4q1mqm@AZSMGA002.ch.intel.com>
 <A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A941F80C-7EDB-4FCF-A8DE-4AE5532D2CB5@logic.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 21:32:53 +0900, Norbert Preining wrote:
> Hi Chris,
> 
> 
> > so can you
> > please file a bug on bugzilla.freedesktop.org (or bugzilla.kernel.org)
> > so that we don't lose track of it.
> 
> Will do when I'm back from the mountains.
> 
> > If your have the option, can you switch the ddx between using SNA and
> > UXA.
> 
> ??? Is that a BIOS option? Or kernel?
> I can try both.

It is an option in the Intel Xorg driver. What is actually used depends
on the options provided to the configure script during build time. You
can see the current state in nur Xorg.0.log.

Here is an example of /etc/X11/xorg.conf which enforces SNA:

Section "Device"
        Option     "AccelMethod" "SNA"
        Identifier  "Card0"
        Driver      "intel"
EndSection

Regards,
Tino
