Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404Ab1ALWYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:24:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153Ab1ALWYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:24:38 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
 <AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
 <20110112114649.5365d518@jbarnes-desktop> <AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com>
 <AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 14:24:17 -0800
Message-ID: <AANLkTi=80ccp1LtcXw1zO-7Rp58_+9yw-tebkJr67g9M@mail.gmail.com>
Subject: Re: [git pull] drm intel only fixes
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 1:28 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oh, and I'm also seeing corruption on my sandybridge machine. No video
> involved, the gdm login screen is already corrupted this way. Similar
> odd shifted lines etc, so I'd assume it's related.

Hmm. I bisected it down to

  commit 6fe4f14044f181e146cdc15485428f95fa541ce8
  Author: Chris Wilson <chris@chris-wilson.co.uk>
  Date:   Mon Jan 10 17:35:37 2011 +0000

      drm/i915/execbuffer: Reorder binding of objects to favour restrictions

on my sandybridge machine.  Chris?

                       Linus
