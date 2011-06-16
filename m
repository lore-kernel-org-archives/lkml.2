Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab1FPQ6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 12:58:32 -0400
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:38263 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432Ab1FPQ6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 12:58:31 -0400
Date: Thu, 16 Jun 2011 13:57:42 -0300
From: Leandro Lucarella <luca@llucax.com.ar>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org
Subject: Re: Graphic corruption with i915 (2.6.39.1)
Message-ID: <20110616165742.GS20487@llucax.com.ar>
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

OK, I had CONFIG_DEBUGFS but never mounted it. Unfortunately I rebooted
since the problem, so now that file says: no error state collected

I'll get the contents when it happens again.

-- 
Leandro Lucarella (AKA luca)                     http://llucax.com.ar/
----------------------------------------------------------------------
GPG Key: 5F5A8D05 (F8CD F9A7 BF00 5431 4145  104C 949E BFB6 5F5A 8D05)
----------------------------------------------------------------------
The world's best known word is "okay"
The second most well-known word is "Coca-Cola"
