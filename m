Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212Ab2DKU27 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:28:59 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:25103 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753671Ab2DKU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:28:57 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 4/8 v7] drm/i915/intel_i2c: use WAIT cycle, not STOP
To: Daniel Kurtz <djkurtz@chromium.org>, Daniel Kurtz <djkurtz@chromium.org>,
        Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>
In-Reply-To: <CAGS+omD9dTTK4gRERy406nLFEMfqC=hw6ZFe3_V9yacSR2r9Sw@mail.gmail.com>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org> <1333108003-6341-5-git-send-email-djkurtz@chromium.org> <20120410103746.GH4115@phenom.ffwll.local> <20120410104147.GI4115@phenom.ffwll.local> <CAGS+omAjDPxs1qR-EwzKhjE9c5J26fZinv6+5RFz1RyAsfStmw@mail.gmail.com> <20120410150304.GJ4115@phenom.ffwll.local> <CAGS+omD9dTTK4gRERy406nLFEMfqC=hw6ZFe3_V9yacSR2r9Sw@mail.gmail.com>
Date: Wed, 11 Apr 2012 21:28:47 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1334176129_372754@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 02:16:45 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> On Tue, Apr 10, 2012 at 11:03 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > - Chris Wilson suggested on irc that we should wait for HW_READY even for
> >  zero-length writes (and also reads), currently we don't.
> 
> I don't think so.  We just need to wait for (GMBUS_SATOER |
> GMBUS_HW_WAIT_PHASE).
> Why would we wait for HW_READY, too?

Just paranoia when looking at the read/write sequences and wondering how
safe they were with 0-length read/writes. No real reason to suspect that
the code is incorrect in any way.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
