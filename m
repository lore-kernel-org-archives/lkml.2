Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2HKTpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 15:45:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46702 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2HKTpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 15:45:09 -0400
Date: Sat, 11 Aug 2012 21:45:29 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Benoit Gschwind <gschwind@gnu-log.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915: ingore eDP bpc settings
Message-ID: <20120811194529.GD5132@phenom.ffwll.local>
Mail-Followup-To: Benoit Gschwind <gschwind@gnu-log.net>,
	Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
References: <1344589820-9753-1-git-send-email-daniel.vetter@ffwll.ch>
 <5024E15D.4090102@gnu-log.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5024E15D.4090102@gnu-log.net>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2012 at 12:24:29PM +0200, Benoit Gschwind wrote:
> 
> Hello,
> 
> I confirm this patch work apply to kernel 3.6-rc1

Ok, I've picked this up for -fixes, with the commit message a bit
improved. Let's see whether this blows up anywhere.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
