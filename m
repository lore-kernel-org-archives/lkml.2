Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2DMM02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:26:28 -0400
Received: from smtp.fireflyinternet.com ([109.228.6.236]:65357 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677Ab2DMM01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:26:27 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 1/2] drm/i915/intel_i2c: handle zero-length reads
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
References: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
Date: Fri, 13 Apr 2012 13:26:13 +0100
X-Originating-IP: 78.156.66.37
Message-ID: <1334319981_407756@CP5-2952>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also,

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=48269
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
