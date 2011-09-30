Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1I3SAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:00:38 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43336 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028Ab1I3SAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:00:36 -0400
Date: Fri, 30 Sep 2011 20:01:11 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 13/21] drm/i915: Place long delays after each
 eDP VDD operation
Message-ID: <20110930180111.GO2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-14-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-14-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:45PM -0700, Keith Packard wrote:
> This ensures that the panel power sequencing is complete before
> attempting to communicate over the aux channel.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
Looks like a patch useful for fixing up this mess, but I don't quite see
the point of merging this given that you fix things for real in the next
one ... 
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
