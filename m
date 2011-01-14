Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab1ANRhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 12:37:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019Ab1ANRhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 12:37:41 -0500
MIME-Version: 1.0
In-Reply-To: <1bdc18$j8l825@fmsmga002.fm.intel.com>
References: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com>
 <1294916869-2417-1-git-send-email-chris@chris-wilson.co.uk>
 <AANLkTimypim707rEXaPBaKoGgGmz3Of4EmPNw7VokJL6@mail.gmail.com> <1bdc18$j8l825@fmsmga002.fm.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jan 2011 09:37:20 -0800
Message-ID: <AANLkTinq9MOjvHVFb1eJ_Dt+vkgpixuUrU-xcDYGZ5Lj@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/execbuffer: Clear domains before beginning reloc processing
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 8:10 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> They will be in drm-intel-fixes. There have been a couple of other patches,
> for the compiler warning, the typo that Indan spotted and for modparam to
> workaround the U160, so I'll send the pull request it via Dave.

My tree has been in a known-broken state for too damn long now. Please
send the pull request to me directly. Dave may be flooded out in
Brisbane or something.

And if you're not certain about some of the other changes, just tell
me, and I'll apply the fix patches only. Or I will revert the thing
that caused the problem. Having a known-broken tree without the fixes
in it is _not_ acceptable, it just makes testing harder for everybody
else!

                           Linus
