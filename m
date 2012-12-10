Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab2LJJMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 04:12:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43933 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab2LJJMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 04:12:37 -0500
Date: Mon, 10 Dec 2012 10:14:07 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2 linux-next] i915: intel_set_mode: Reduce stack
 allocation from 500 bytes to 2 pointers
Message-ID: <20121210091407.GI11556@phenom.ffwll.local>
Mail-Followup-To: Jani Nikula <jani.nikula@linux.intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org
References: <87zk1qm6cd.fsf@intel.com>
 <1354892066-30256-1-git-send-email-tim.gardner@canonical.com>
 <87obi2mkky.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obi2mkky.fsf@intel.com>
X-Operating-System: Linux phenom 3.7.0-rc2+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 09:29:17AM +0200, Jani Nikula wrote:
> On Fri, 07 Dec 2012, Tim Gardner <tim.gardner@canonical.com> wrote:
> > smatch warning:
> >
> > drivers/gpu/drm/i915/intel_display.c:7019 intel_set_mode() warn: function puts
> > 500 bytes on stack
> >
> > Refactor so that saved_mode and saved_hwmode are dynamically allocated as opposed
> > to being automatic variables. 500 bytes seems like it could run the potential for blowing
> > the kernel stack.
> 
> Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
