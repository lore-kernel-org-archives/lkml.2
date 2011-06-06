Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab1FFUgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:36:42 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:32779 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753834Ab1FFUgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:36:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hkKPb5XZE1oPxvL9+o2rnT0z+LBUKkdkTne7AIsOy9Xi3YodqPGChSO3E2CzwFiDzI0pEu9GQnGwHy1paDHypi8a02tz92palmReuneEdjuyQuzYycv9585TkLm4x9iC;
Date: Mon, 6 Jun 2011 13:36:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Keith Packard" <keithp@keithp.com>
Cc: dri-devel@lists.freedesktop.org,
        "drivers, Intel" <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: drivers/drm/i915 maintenance process
Message-ID: <20110606133618.478fc5d9@jbarnes-desktop>
In-Reply-To: <yunipskolss.fsf@aiko.keithp.com>
References: <yunipskolss.fsf@aiko.keithp.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Jun 2011 23:05:23 -0700
"Keith Packard" <keithp@keithp.com> wrote:

>  1) drm-intel-next
> 
>     This contains work destined for the 'next' release, it may include
>     new functionality and performance enhancements. It may also cause
>     regressions on some hardware. The tip of this tree will be sent
>     to Dave Airlie for inclusion in the kernel during the next
>     merge window. I've already sent all of what is on this branch
>     to him for 3.0
> 
>     This tree should be tested during the development process to try and
>     catch bugs and regressions before they are merged. The most critical
>     time for testing this is just *before* the release of the current RC
>     kernel version as that is when it should have most of the code
>     planned for the *next* release.
> 
>  2) drm-intel-fixes
> 
>     This contains bug fixes after the merge window has closed. I will
>     fast-forwarded to each RC when possible so that we test the fully
>     integrated kernel for regressions.
> 
>     This tree should be tested during the stabilization process after RC1
>     comes out as patches are applied.

Can you keep drm-intel-next fairly up to date with respect to the fixes
branch?  I.e. keep it a superset of drm-intel-fixes for the most part?

In PCI-land, this means re-basing my -next tree periodically before the
merge window opens (though not right before the merge window unless
something unexpected happens, like a patch needing to be dropped; in
that case I'll delay the merge window push a bit to allow for more
testing).

Downstream PCI developers requested this since it makes feature
development much easier (you get all the bug fixes destined for Linus
while working on a new feature for the next window), and as a
downstream gfx developer I'd like to see this on the Intel side as
well, unless other developers have big objections...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
