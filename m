Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0IIRJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:09:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:29677 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab0IIRJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:09:45 -0400
Message-Id: <8u3s94$gfdh5f@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,340,1280732400"; 
   d="scan'208";a="553043119"
Date: Thu, 09 Sep 2010 18:09:40 +0100
To: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] i915: Add native backlight control
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        Matthew Garrett <mjg@redhat.com>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com> <1283963539-4039-2-git-send-email-mjg@redhat.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1283963539-4039-2-git-send-email-mjg@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Sep 2010 12:32:18 -0400, Matthew Garrett <mjg@redhat.com> wrote:
> Not all systems expose a firmware or platform mechanism for changing the
> backlight intensity on i915, so add native driver support.

This will conflict with a similar patch I have in drm-intel-next to unify
the various bits of code that were attempting to modify the BLC PWM, each
in their own unique fashion.

I'll respin this native interface on top of that. Do you want to add a
native RAW interface all in one go, or to base it on the current
backlight_device and then to add the RAW property with this patch set?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
