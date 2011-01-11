Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1AKTMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 14:12:07 -0500
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58833 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756253Ab1AKTMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 14:12:05 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XJhQL5BLyF0A9PhilncC/9xHI5GbQns3mgc0JjJUllJXRVuvCZUa2R8K0bmALB/Ca4KpDCsBOGw2kwyaOBu7GwGp1skvB6aZ8H/LzByU6eXy0v4o1wscn5McCNLNC+23;
Date: Tue, 11 Jan 2011 11:12:03 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Airlie <airlied@linux.ie>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm for rc1
Message-ID: <20110111111203.279eae50@jbarnes-desktop>
In-Reply-To: <AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
	<AANLkTinW8Yp1K1w+G+BgLa-fPaFANkGsRjqH_W8N+9VL@mail.gmail.com>
	<AANLkTim5oVZqMBtan5_TMOxaWbqkF=aDcBYFNYy55kt_@mail.gmail.com>
	<0aea052d-70ff-41ea-8776-c6d974c10337@email.android.com>
	<AANLkTim0rn7Vem6YJM5tVKM0PX4YdnNmaeqmpS=Vp7rc@mail.gmail.com>
	<AANLkTi=eRHbgerpdPYdoOo45LruNTk0rNsWvOO-kYxyQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011 11:00:13 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Jan 11, 2011 at 8:01 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But yes, it worked before pulling Dave's tree, IOW, I haven't seen
> > this message on this machine before.
> 
> .. and it's not a fluke. It happened again, and once more while I was
> away from the machine and the screen saver was running. So it does
> seem to have something to do with power-saving modes or something.

Have you tried reproducing it using xset dpms force off or similar?

Chris, what are you using to trigger the watermark related issues
you've found?

-- 
Jesse Barnes, Intel Open Source Technology Center
