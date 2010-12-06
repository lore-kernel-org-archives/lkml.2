Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab0LFLom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 06:44:42 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:40088 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab0LFLol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 06:44:41 -0500
Date: Mon, 6 Dec 2010 13:44:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Felipe Balbi <balbi@ti.com>, "airlied@linux.ie" <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915 regression (??)
Message-ID: <20101206114436.GB2862@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20100920062841.GA32493@legolas.emea.dhcp.ti.com>
 <8u3s94$giian9@orsmga002.jf.intel.com>
 <20101123091646.GA2308@legolas.emea.dhcp.ti.com>
 <5b55a1$irtpkj@fmsmga002.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <5b55a1$irtpkj@fmsmga002.fm.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 05, 2010 at 02:21:27PM +0000, Chris Wilson wrote:
>On Tue, 23 Nov 2010 11:16:46 +0200, Felipe Balbi <balbi@ti.com> wrote:
>> .37-rc3 and it's still broken. Any ways I could help ? I have at least a
>> machine to test (Dell e6410). It works sometimes out of luck and others,
>> only rebooting.
>
>Dave Airlie bisected the regression and it was duly reverted. That revert
>is available in ickle/drm-intel-fixes, airlied/drm-fixes and linus/master:
>
>commit 3cf2efb1a7c68d55d60dcb2ed9609e1a2fc25952
>Author: Chris Wilson <chris@chris-wilson.co.uk>
>Date:   Mon Nov 29 10:09:55 2010 +0000
>
>    Revert "drm/i915/dp: use VBT provided eDP params if available"
>
>    This reverts commit 869184a675662bddcdf76c5b95665272facff2b8.
>
>    This is required for the Sony Vaio Jesse was working on at the time, but
>    breaks most other eDP machines - machines that were working in earlier
>    kernels.
>
>    Reported-and-tested-by: Dave Airlie <airlied@redhat.com>
>    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=31188
>    Tested-by: Zhao Jian <jian.j.zhao@intel.com>
>    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
>
>Can you test whether this is sufficient for you as well?

Just tested, same problem. I'll check again later if I did something
wrong.

-- 
balbi
