Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab1I3TAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 15:00:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48964 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167Ab1I3TAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 15:00:35 -0400
Date: Fri, 30 Sep 2011 21:01:10 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 21/21] drm/i915: No need to wait for eDP power off delay
 if panel is on
Message-ID: <20110930190110.GY2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-22-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-22-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:53PM -0700, Keith Packard wrote:
> If the panel is powered up, there's no need to delay for the 'off'
> interval when turning the panel on.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

I'll hold off carefully checking this one until the previous patches
settle. Especially when we want to implement the backlight power
sequencing delays, a few things might move around still. Idea sounds good,
though.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
