Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab2DMMZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:25:51 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:65254 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753535Ab2DMMZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:25:50 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/2] drm/i915/intel_i2c: handle zero-length reads
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
References: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
Date: Fri, 13 Apr 2012 13:25:33 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1334319941_407751@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 19:47:53 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> A common method of probing an i2c bus is trying to do a zero-length read.
> Handle this case by checking the length first waiting for data to be read.
> 
> This is actually important, since attempting a zero-length read is one
> of the ways that i2cdetect and i2c_new_probed_device detect whether
> there is device present on the bus with a given address.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

You earlier assuaged my fears that setting SW_READY without waiting
would anger the hw, so

Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
