Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab1CWPdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:33:36 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:44957 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933050Ab1CWPde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:33:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XWr2H0sc3IZ3s1Quq1mIOtPZdVYRhC9N3oNbYv3Nez2haJi3R0zXbmiQmcVGSBnUIiEVL6Hui/a6GK+jBdj3eF7VlccSt6qBJCJQEiMnUhZl2n5FG1rrRUBdhtM5wl6x;
Date: Wed, 23 Mar 2011 08:33:29 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm next tree
Message-ID: <20110323083329.64a738c6@jbarnes-desktop>
In-Reply-To: <AANLkTi=zcXFOGj+pi1YSVY1kHoULEAQRNrnzmw2Pexns@mail.gmail.com>
References: <alpine.DEB.2.00.1103170403160.3429@skynet.skynet.ie>
	<AANLkTinoTs89ThBnZ17+fPE+t1V=GycKq2EJG-LadFZQ@mail.gmail.com>
	<AANLkTi=zcXFOGj+pi1YSVY1kHoULEAQRNrnzmw2Pexns@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Mar 2011 08:29:35 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Mar 22, 2011 at 7:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Keith/Jesse/Chris - I don't know that it's i915, and it will take
> > forever to bisect (I'll try). But it does seem pretty likely.
> 
> Ok, so I'm still bisecting, but it's definitely the DRM pull. Current
> bisection log attached (the result does contain the fbdev pull from
> Paul Mundt, but that doesn't touch any files I compile afaik).

Chris mentioned a7a75c8f7 on irc, not sure if it was regarding this
issue though, but it does seem a likely candidate.

-- 
Jesse Barnes, Intel Open Source Technology Center
