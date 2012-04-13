Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326Ab2DMNDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 09:03:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59721 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2DMNDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 09:03:44 -0400
Date: Fri, 13 Apr 2012 15:04:37 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 2/2] drm/i915/intel_i2c: reduce verbosity of some messages
Message-ID: <20120413130437.GF4525@phenom.ffwll.local>
Mail-Followup-To: Daniel Kurtz <djkurtz@chromium.org>,
	Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	Chris Wilson <chris@chris-wilson.co.uk>
References: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
 <1334317674-32450-2-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334317674-32450-2-git-send-email-djkurtz@chromium.org>
X-Operating-System: Linux phenom 3.2.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 07:47:54PM +0800, Daniel Kurtz wrote:
> Some of these messages can be hit when userspace tries to probe the i2c
> with nothing connected or if the driver code tries to do the same. See:
> https://bugs.freedesktop.org/show_bug.cgi?id=48248
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Both patches queued for -next, thanks a lot for all the work you've put
into beating gmbus into shape.
- Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
