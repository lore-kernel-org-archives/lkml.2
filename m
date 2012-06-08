Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab2FHWQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:16:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56021 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab2FHWQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <1339193608_596134@CP5-2952>
References: <alpine.DEB.2.00.1206080952010.15272@skynet.skynet.ie>
 <CA+55aFyASr5Jfok7vVKXg9=n_pBGyjLZf3MmRik90y8qXRNo3g@mail.gmail.com> <1339193608_596134@CP5-2952>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 8 Jun 2012 15:16:14 -0700
X-Google-Sender-Auth: 1Grp12iEQcfi_cwg9MhLoysUTNw
Message-ID: <CA+55aFwkUfpc_QwoquDAeRPOj_h5jY2WHDRqqVO-bAH31m86bw@mail.gmail.com>
Subject: Re: [git pull] drm intel + exynos fixes
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 3:12 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> Shock, horror, that's how it is meant to work when we cannot determine
> whether or not there is actually an output attached to the VGA.

We don't break existing installations. And that existing installation
has worked for a long time. You broke it, it's a regression, get over
it. It's reverted, and it stays reverted.

                   Linus
