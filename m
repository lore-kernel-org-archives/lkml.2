Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab0IIROP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:14:15 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:51407 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0IIRON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:14:13 -0400
Date: Thu, 9 Sep 2010 18:14:09 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [PATCH] i915: Add native backlight control
Message-ID: <20100909171409.GA25746@srcf.ucam.org>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com> <1283963539-4039-2-git-send-email-mjg@redhat.com> <8u3s94$gfdh5f@orsmga002.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8u3s94$gfdh5f@orsmga002.jf.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 06:09:40PM +0100, Chris Wilson wrote:
> On Wed,  8 Sep 2010 12:32:18 -0400, Matthew Garrett <mjg@redhat.com> wrote:
> > Not all systems expose a firmware or platform mechanism for changing the
> > backlight intensity on i915, so add native driver support.
> 
> This will conflict with a similar patch I have in drm-intel-next to unify
> the various bits of code that were attempting to modify the BLC PWM, each
> in their own unique fashion.
> 
> I'll respin this native interface on top of that. Do you want to add a
> native RAW interface all in one go, or to base it on the current
> backlight_device and then to add the RAW property with this patch set?

I don't think providing a native interface in i915 is beneficial without 
providing the type information - userspace just doesn't have any way to 
identify the correct device otherwise.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
