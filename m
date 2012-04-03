Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2DCWyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:54:55 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:12405 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755787Ab2DCWyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:54:54 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/8 v7] drm/i915/intel_i2c: handle zero-length writes
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1333108003-6341-2-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org> <1333108003-6341-2-git-send-email-djkurtz@chromium.org>
Date: Tue, 03 Apr 2012 23:54:18 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1333493687_224682@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 19:46:36 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> A common method of probing an i2c bus is trying to do a zero-length write.
> Handle this case by checking the length first before decrementing it.
> 
> This is actually important, since attempting a zero-length write is one
> of the ways that i2cdetect and i2c_new_probed_device detect whether
> there is device present on the bus with a given address.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Having done a good job with handling zero length writes, can I tempt to
submit a similar fix for zero length reads? ;)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
