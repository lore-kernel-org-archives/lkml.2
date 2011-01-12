Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab1ALXGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:06:45 -0500
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:38381 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750741Ab1ALXGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:06:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=gH1hxCCljYm5hgSIRXjXdJKXYC2EqV8kg3zsXprnMRZMRREzcM+7WOeDWFr0K63tcPBe4iRJD4k8yKaqvXyVK2TDKafVkGkNypKDSYBSaFP983J5OKFLZnx22w5Uhjrr;
Date: Wed, 12 Jan 2011 15:06:40 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm intel only fixes
Message-ID: <20110112150640.2a41602c@jbarnes-desktop>
In-Reply-To: <AANLkTinbyTOirefH91=9feSAUZtgRO1xyHsZsewfz3DG@mail.gmail.com>
References: <alpine.DEB.2.00.1101120601100.6210@skynet.skynet.ie>
	<AANLkTimgs8UfGWk5PCZi4PM5SsvejJd5Y4bb3nHGyZy2@mail.gmail.com>
	<20110112114649.5365d518@jbarnes-desktop>
	<AANLkTinSygbLm=nmXy_Wf2ENV8WcQqCc0BKAAOsysvZd@mail.gmail.com>
	<AANLkTimSKOa8XavLn_RsLZ2scZ=ujdYahcTkeJ2pxBFq@mail.gmail.com>
	<20110112142206.37a1b76d@jbarnes-desktop>
	<AANLkTinbyTOirefH91=9feSAUZtgRO1xyHsZsewfz3DG@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 14:31:33 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Jan 12, 2011 at 2:22 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> >
> > Ah, ok.  So it could be our internal FDI link is underrunning; it goes
> > between the CPU and PCH and carries display bits.
> 
> I'm not sure it's an underrun or anything like that: the corruption is
> long-term in the non-video case. So I take back the "looks like memory
> bandwidth problems", because it really looks more like a corrupted
> blit operation there.

Ah ok if it's long running then yeah it's more likely to be a rendering
issue.  It could also be the FDI link getting its timings messed up
though, and consistently delivering the wrong bits; that could show up
in the same place on the screen each time, or it might move in a
pattern across the screen (usually from top to bottom).

> Will do. I'll have to reboot to the broken kernel (my bisection ended
> in a non-broken case)

Great, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
