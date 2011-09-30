Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab1I3R0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:26:18 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55311 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab1I3R0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:26:17 -0400
Date: Fri, 30 Sep 2011 19:26:52 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 11/21] drm/i915: Enable eDP panel power during I2C
 initialization sequence
Message-ID: <20110930172652.GJ2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-12-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-12-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:43PM -0700, Keith Packard wrote:
> The DP i2c initialization code does a couple of i2c transactions,
> which means that an eDP panel must be powered up.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Ah, here's the code I've been looking for when reviewing patch 9.
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
