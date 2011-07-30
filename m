Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1G3Pdy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 11:33:54 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:50505 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab1G3Pdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 11:33:49 -0400
X-Greylist: delayed 1840 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Jul 2011 11:33:49 EDT
Date: Sat, 30 Jul 2011 12:02:14 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org
Subject: Re: Graphic corruption with i915 (2.6.39.1)
Message-ID: <20110730150214.GK3182@llucax.com.ar>
References: <20110616145842.GM20487@llucax.com.ar>
 <013811$g9fu7@fmsmga002.fm.intel.com>
 <20110616161803.GQ20487@llucax.com.ar>
 <aefc95$f0ne9@orsmga001.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aefc95$f0ne9@orsmga001.jf.intel.com>
X-Paranoid: Just because you're paranoid, don't mean they're not after you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson, el 16 de junio a las 17:39 me escribiste:
> On Thu, 16 Jun 2011 13:18:03 -0300, Leandro Lucarella <luca@llucax.com.ar> wrote:
> > cannot access /sys/kernel/debug/dri/0/i915_error_state: No such file or directory
> > 
> > The debug directory is not present, should I boot or compile with some
> > particular option to enable it?
> 
> You need to compile with CONFIG_DEBUGFS and at runtime
> "mount -tdebugfs debug /sys/kernel/debug".
> 
> The /sys/kernel/debug/dri/0/i915_error_state will only be populated
> after a hang is detected.

OK, I'm having another i915 "episode" and now I have the debugfs
mounted. Here is the contents of
/sys/kernel/debug/dri/0/i915_error_state:
http://llucax.com.ar/tmp/i915_error_state.txt (1.4MiB)

Here is the error message shown in dmesg:

[1259708.264742] Out of memory: Kill process 16640 (firefox-bin) score 504 or sacrifice child
[1259708.264748] Killed process 13128 (plugin-containe) total-vm:450880kB, anon-rss:19588kB, file-rss:780kB
[1259726.000008] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU hung
[1259726.000014] [drm] capturing error event; look for more information in /debug/dri/0/i915_error_state
[1259726.001254] [drm:i915_wait_request] *ERROR* i915_wait_request returns -11 (awaiting 28517162 at 28517161, next 28517164)
[1259726.503009] [drm:i915_reset] *ERROR* Failed to reset chip.

Any ideas? Thanks!

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
The average person laughs 13 times a day
