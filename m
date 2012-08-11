Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227Ab2HKTPl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 15:15:41 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62489 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab2HKTPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 15:15:38 -0400
Date: Sat, 11 Aug 2012 21:15:53 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Takashi Iwai <tiwai@suse.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Giacomo Comes <comes@naic.edu>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/i915: Fix blank panel at reopening lid
Message-ID: <20120811191553.GA5132@phenom.ffwll.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Giacomo Comes <comes@naic.edu>,
	Paulo Zanoni <paulo.r.zanoni@intel.com>,
	linux-kernel@vger.kernel.org
References: <s5h3941ke2p.wl%tiwai@suse.de>
 <alpine.LSU.2.00.1208052113530.1300@eggly.anvils>
 <CAKMK7uHZ3F9neO6=ZX2MFLzYmincPeEF23udgZ-0YJ0R+WHEkg@mail.gmail.com>
 <alpine.LSU.2.00.1208061122060.1425@eggly.anvils>
 <s5h1ujfyn39.wl%tiwai@suse.de>
 <CAKMK7uF_5K6d=xw7SsRJqw7dg5ca6HMdf3jvsQcQqhmSNLkaww@mail.gmail.com>
 <s5hpq6yyke5.wl%tiwai@suse.de>
 <alpine.LSU.2.00.1208101145440.2648@eggly.anvils>
 <s5hvcgq7wpp.wl%tiwai@suse.de>
 <s5hsjbt9as5.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hsjbt9as5.wl%tiwai@suse.de>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 11, 2012 at 08:56:42AM +0200, Takashi Iwai wrote:
> When you reopen the lid on a laptop with PCH, the panel suddenly goes
> blank sometimes.  It seems because BLC_PWM_CPU_CTL register is cleared
> to zero when BLC_PWM_CPU_CTL2 and BLC_PWM_PCH_CTL1 registers are
> enabled.
> 
> This patch fixes the problem by moving the call of the function setting
> BLC_PWM_CPU_CTL after enabling other two registers.
> 
> Reported-and-tested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
> v1->v2: add comments, fixed changelog
Picked up for -fixes, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
