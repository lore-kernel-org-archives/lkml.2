Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab2ISHae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:30:34 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64437 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2ISHac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:30:32 -0400
Date: Wed, 19 Sep 2012 09:30:27 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] [RESEND] console: implement lockdep support for
 console_lock
Message-ID: <20120919073027.GB1676@bremse>
Mail-Followup-To: Jani Nikula <jani.nikula@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	DRI Development <dri-devel@lists.freedesktop.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <1347923013-4253-1-git-send-email-daniel.vetter@ffwll.ch>
 <1347923013-4253-2-git-send-email-daniel.vetter@ffwll.ch>
 <87627b9453.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87627b9453.fsf@intel.com>
X-Operating-System: Linux bremse 3.6.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 10:33:28AM +0300, Jani Nikula wrote:
> On Tue, 18 Sep 2012, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> > +#ifdef CONFIG_LOCKDEP
> > +struct lockdep_map console_lock_dep_map = {
> > +	.name = "console_lock"
> > +};
> > +#endif
> 
> static?

Yeah, static. I'm travelling atm, so will take a while to resend ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
