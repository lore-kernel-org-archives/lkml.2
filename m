Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341Ab1IOR4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 13:56:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:32844 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040Ab1IOR4x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 13:56:53 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
Date: Thu, 15 Sep 2011 19:56:52 +0200
X-Google-Sender-Auth: pHKLSELslazzvRVfLnDzPU8i5AQ
Message-ID: <CAMuHMdUoYi5xTQz=v1rCycS23vFgQzeZFbNZGnrRN+qkBCrSRA@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Keith Packard <keithp@keithp.com>, linux-fbdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Archit Taneja <archit@ti.com>,
        "Clark, Rob" <rob@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 19:52, Alex Deucher <alexdeucher@gmail.com> wrote:
> While the DRM has historically targeted 3D acceleration, that is not a
> requirement to use the DRM KMS modesetting API.  The current fb API
> has no concept of display controllers or connectors or overlays, etc.
> To match it to modern hardware, it needs a major overhaul.  Why create
> a new modern fb interface that's largely the same as DRM KMS?  What if
> we just consider the KMS API as the new fb API?  If there are any
> inadequacies in the DRM KMS API we would be happy to work out any
> changes.

I admit I didn't look for it, but does there exist a sample DRM KMS driver
for dumb frame buffer hardware with one fixed video mode?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
