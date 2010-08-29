Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0H2N2C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 09:28:02 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:37582 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0H2N2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 09:28:01 -0400
Date: Sun, 29 Aug 2010 14:27:53 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: maciej.rutecki@gmail.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PROBLEM] i915/drm: Insufficient FIFO for plane
Message-ID: <20100829132753.GA19049@sucs.org>
References: <alpine.DEB.2.00.1008221821370.4027@tiger> <201008262027.24729.maciej.rutecki@gmail.com> <AANLkTikMK7WJAfBHUXi_VMyJQBQT69ZfA7LwKfp5c-r8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikMK7WJAfBHUXi_VMyJQBQT69ZfA7LwKfp5c-r8@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 29, 2010 at 02:32:41PM +0300, Pekka Enberg wrote:
> 
> The "insufficient FIFO for plane" problem seems to have gone away with
> latest Linus' git. I suppose commit
> 9559fcdbff4f93d29af04478bbc48294519424f5 ("drm/i915: fix vblank wait
> test condition") fixed it although I don't see any mention of the
> error in the changelog?

I found that commit reduced the number of "insufficient FIFO for plane"
messages in certain circumstances too (when the system is stable I only
see one at boot). However when my system is in "unstable mode" (see
http://marc.info/?l=linux-kernel&m=128272404206696&w=2 ), I can still
generate that message using the modetest (at the console) or xrandr (in
X) tools or by doing VT switches. When this is the case, the message
generally arrives in batches of two.

-- 
Sitsofe | http://sucs.org/~sits/
