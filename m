Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab1I3R5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 13:57:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35361 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1I3R5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 13:57:46 -0400
Date: Fri, 30 Sep 2011 19:58:21 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 03/21] drm/i915: Remove extra 300ms delay during eDP mode
 setting
Message-ID: <20110930175821.GN2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	"Barnes, Jesse" <jbarnes@virtuousgeek.org>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-4-git-send-email-keithp@keithp.com>
 <20110930162728.GC2859@phenom.ffwll.local>
 <yun7h4p9ay5.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun7h4p9ay5.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 10:50:10AM -0700, Keith Packard wrote:
> On Fri, 30 Sep 2011 18:27:28 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > Can you elaborate a bit why this is no longer needed? Jesse seems to have
> > introduced this spefically for edp panels in d209848d61794968. If this
> > becomes rendundant due to your panel power sequencing fixes, maybe move it
> > down the series?
> 
> The only reason for this delay is to avoid some potential noise on the
> screen during mode setting, all of the power sequencing delays are
> already correctly managed by the driver. As far as I can tell, we're
> trading off the small potential for noise on the screen with an extra
> 300ms delay at boot time.
> 
> In the eDP spec, there's a delay listed (T8) between the start of video
> data and turning on the backlight. There are no values presented and
> the instructions are simply that the source is supposed to wait until
> the display is stable. I'm not sure how we'd ever know that the display
> is stable.

Ok, maybe add the above to paragraphs to the commit msg. Then
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
