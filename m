Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2APT7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:59:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53864 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab2APT7U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:59:20 -0500
MIME-Version: 1.0
In-Reply-To: <20120116194132.GC3627@phenom.ffwll.local>
References: <20120116194132.GC3627@phenom.ffwll.local>
From: Eugeni Dodonov <eugeni@dodonov.net>
Date: Mon, 16 Jan 2012 17:58:39 -0200
X-Google-Sender-Auth: kwaTa8vbzG7eh0QkhHC7iBxjPCc
Message-ID: <CAC7LmntCGG_DRaiNKSNxjo=hw6eZJuBQCaCxf8uXTP=S2CAq+g@mail.gmail.com>
Subject: Re: New drm-intel-next tree
To: Dave Airlie <airlied@gmail.com>, Keith Packard <keithp@keithp.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 17:41, Daniel Vetter <daniel@ffwll.ch> wrote:
>
> Hi all,
>
> Because Keith is routinely really busy with all kinds of things, notably
> gathering fixes for drm-intel-fixes, the patch merge process for the next
> release cycle sometimes falls behind. To support him and improve things I've
> been volunteered to take over handling the -next tree.
>
> The main aim is to shift the drm/i915 -next merge process massively ahead with
> the goals to:
> - Reduce pressure to merge questionable patches into -rc kernels because the
>  -next tree is not yet open for patches.
> - Allow our QA at Intel and also the community to actually test things before
>  they land in mainline. The lack of such testing has severly bitten us in the
>  past few releases.
> - Refocus -fixes on handling regressions with absolute top priority (as it
>  should).
> - And generally get a steady and predictable patch-flow towards mainline back
>  into gears.

Following up on Daniel's mail, I discussed with him, and from now on I
intend to include the -next patches into the -drm-intel-backports [1]
as well, to simplify testing for ones of you running stable kernels
who want to test the latest breakages^w features :).

[1] http://comments.gmane.org/gmane.comp.freedesktop.xorg.drivers.intel/7961

--
Eugeni Dodonov
