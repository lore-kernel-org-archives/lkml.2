Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0LYNkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 08:40:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:29407 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0LYNkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 08:40:45 -0500
Message-Id: <c6d829$pvchrr@fmsmga001.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,227,1291622400"; 
   d="scan'208";a="871778171"
Date: Sat, 25 Dec 2010 13:38:56 +0000
To: Jarek Poplawski <jarkao2@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc7] drivers/gpu/drm/drm_edid.c:1303: warning: array subscript is above array bounds
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
In-Reply-To: <20101225131343.GA1960@del.dom.local>
References: <20101225131343.GA1960@del.dom.local>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Dec 2010 14:13:43 +0100, Jarek Poplawski <jarkao2@gmail.com> wrote:
> Hi,
> There is this compile warning in Linus' tree (gcc version 4.3.3):
> 
> drivers/gpu/drm/drm_edid.c: In function 'drm_detect_hdmi_monitor':
> drivers/gpu/drm/drm_edid.c:1303: warning: array subscript is above array bounds
> drivers/gpu/drm/drm_edid.c: In function 'drm_detect_monitor_audio':
> drivers/gpu/drm/drm_edid.c:1303: warning: array subscript is above array bounds

What array? It's declared as "u8 *edid_ext;". At first glance looks like a
compiler bug, applying subscript testing to an object with unknown bounds.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
