Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0LHRIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 12:08:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:25187 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0LHRIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 12:08:09 -0500
Message-Id: <0d30dc$kddq6q@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,316,1288594800"; 
   d="scan'208";a="685172954"
Date: Wed, 08 Dec 2010 17:08:04 +0000
To: Florian Mickler <florian@mickler.org>, Keith Packard <keithp@keithp.com>
Subject: Re: [Intel-gfx] [PATCH 2/2] drm: record monitor status in output_poll_execute
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20101208173424.76ec4041@schatten.dmk.lab>
References: <1290797159-3977-1-git-send-email-keithp@keithp.com> <1290797159-3977-2-git-send-email-keithp@keithp.com> <20101205132743.3b3458ab@schatten.dmk.lab> <yunpqtgexml.fsf@aiko.keithp.com> <20101208173424.76ec4041@schatten.dmk.lab>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010 17:34:24 +0100, Florian Mickler <florian@mickler.org> wrote:
> Does that mean that the kernel regression will not be
> fixed/worked-around for old userspace? 

I think there is some confusion in that I believe there is more than one
backlight bug at play here.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
