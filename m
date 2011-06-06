Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1FFXul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:50:41 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:42892 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751574Ab1FFXuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:50:40 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 19:50:40 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=SCz5PQ3HhA+NGESW+QOKT56zQru2lbLF9OpFy6yb4YllxDvsJw04q4PqFiqQow1Iz09536dlBg7UiEpvA1uc2w5RgKDDUDSkMBpkeoS0DbSckxCHwpCzpvqJ2I6UR4LI;
Date: Mon, 6 Jun 2011 16:43:35 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Keith Packard <keithp@keithp.com>
Cc: "drivers, Intel" <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] drivers/drm/i915 maintenance process
Message-ID: <20110606164335.10bdea9d@jbarnes-desktop>
In-Reply-To: <20110606163025.5b1bfdee@jbarnes-desktop>
References: <yunipskolss.fsf@aiko.keithp.com>
	<20110606133618.478fc5d9@jbarnes-desktop>
	<yun39jm1r29.fsf@aiko.keithp.com>
	<20110606163025.5b1bfdee@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011 16:30:25 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Mon, 06 Jun 2011 16:24:46 -0700
> Keith Packard <keithp@keithp.com> wrote:
> 
> > On Mon, 6 Jun 2011 13:36:18 -0700, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > Can you keep drm-intel-next fairly up to date with respect to the fixes
> > > branch?  I.e. keep it a superset of drm-intel-fixes for the most part?
> > 
> > Yes, I wanted to do that now, but -fixes is not a fast-forward from
> > -next and I thought I shouldn't be doing rebases.
> 
> You shouldn't if your downstream is using git trees and you're pulling
> from them, but it depends on your downstream.  In my particular case,
> I'm ok with rebases if it means I get fixes. :)

Oh and the other big reason is testing.  rebase generally voids
previous testing since you have new bits, so Linus really hates to see
a rebase just before a pull request, and I think Dave does too.

But rebasing for good reason (e.g. to make your -next branch a superset
of your -fixes branch) on occasion is fine.

-- 
Jesse Barnes, Intel Open Source Technology Center
