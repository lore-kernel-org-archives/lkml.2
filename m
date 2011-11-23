Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1KWKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 05:25:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48126 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab1KWKZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 05:25:27 -0500
Date: Wed, 23 Nov 2011 11:26:43 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/i915: By default, enable RC6 on IVB and SNB when
 reasonable
Message-ID: <20111123102643.GB3864@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Matthew Garrett <mjg@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org
References: <1321684889-18691-1-git-send-email-keithp@keithp.com>
 <20111122201531.GD5547@srcf.ucam.org>
 <861uszfrah.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <861uszfrah.fsf@sumi.keithp.com>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 07:31:34PM -0800, Keith Packard wrote:
> On Tue, 22 Nov 2011 20:15:31 +0000, Matthew Garrett <mjg@redhat.com> wrote:
> 
> > So the user has to choose between 5W of power saving or having dmar? And 
> > we default to giving them dmar? I think that's going to come as a 
> > surprise to people.
> 
> You'd have to go into the BIOS to turn this on for most machines at
> least?
> 
> But, yeah, it seems like we should be turning DMAR off unless explicitly
> requested; I can't understand how you'd ever need this running native on
> the hardware. Not exactly an area I care about deeply; I've always
> worked hard to make sure all virtualization garbage is disabled on every
> machine I use.

Problem is that we need to disable dmar on the entire box, afaics. And I
assume that a bunch of people abusing desktop boards as servers will call
"regression" on that.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
