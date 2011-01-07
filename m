Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab1AGT2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:28:32 -0500
Received: from dhael.aehallh.com ([199.73.30.2]:43363 "EHLO dhael.aehallh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1AGT2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:28:31 -0500
X-Greylist: delayed 471 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Jan 2011 14:28:31 EST
Date: Fri, 7 Jan 2011 14:20:39 -0500
From: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org
Subject: Re: Linux 2.6.37
Message-ID: <20110107192039.GO6307@aehallh.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	dri-devel@lists.freedesktop.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Jan 2011 11:50:02 +0100, Michal Hocko wrote:
> Hi,
> 
> On Tue 04-01-11 17:15:45, Linus Torvalds wrote:
> [...]
> > We did have another revert to fix hopefullythe last "blank screen"
> > regression on intel graphics.
> 
> It seems that there is still a regression for intel graphic cards
> backlight. One report is
> https://bugzilla.kernel.org/show_bug.cgi?id=22672.
> I can reproduce the problem easily by:
> xset dpms force standby; sleep 3s; xset dpms force on
> 
> backlight doesn't get up (there is really dark picture though which
> doesn't get brighter by function keys which work normally) after dpms on
> until I close and open lid.
> 
> The problem wasn't present in 2.6.36

And I have a different regression.

On 2.6.36.2 everything is fine, on 2.6.37 my laptop's display is more or
less blank, backlight on, with a white pattern slowly moving across the
screen like it was a (bad) moving spot light effect.

dmesg output and .configs at
https://bugs.freedesktop.org/show_bug.cgi?id=32903

Zephaniah E. Loss-Cutler-Hull.
