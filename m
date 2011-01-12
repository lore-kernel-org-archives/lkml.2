Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1ALWc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:32:29 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53075 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754157Ab1ALWc1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:32:27 -0500
MIME-Version: 1.0
In-Reply-To: <20110112142206.37a1b76d@jbarnes-desktop>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
 <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
 <20110112114649.5365d518@jbarnes-desktop> <AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com>
 <AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com> <20110112142206.37a1b76d@jbarnes-desktop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 14:31:33 -0800
Message-ID: <AANLkTinbyTOirefH91=9feSAUZtgRO1xyHsZsewfz3DG@mail.gmail.com>
Subject: Re: [git pull] drm intel only fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 2:22 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>
> Ah, ok.  So it could be our internal FDI link is underrunning; it goes
> between the CPU and PCH and carries display bits.

I'm not sure it's an underrun or anything like that: the corruption is
long-term in the non-video case. So I take back the "looks like memory
bandwidth problems", because it really looks more like a corrupted
blit operation there.

> Are these both desktop type machines with DVI attached monitors?

DVI on the Core i5, plain analog VGA on the sandybridge one (I can
hear you asking "Why?". Because the silly intel motherboard doesn't
_have_ DVI out, and I didn't have a hdmi cable)

> If it's an FDI or transcoder problem, something like the below may give
> us more info.

See above. It's long-term, it was just the video behavior that made me
originally think it was temporary.

> Can you take a picture of the corruption?

Will do. I'll have to reboot to the broken kernel (my bisection ended
in a non-broken case)

                  Linus
