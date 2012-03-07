Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081Ab2CGMMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:12:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:22762 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758039Ab2CGMMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:12:40 -0500
Message-Id: <aefc95$3e4bn0@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="115486432"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [PATCH 6/9] drm/i915/intel_i2c: return -ENXIO for device NAK
To: Daniel Kurtz <djkurtz@chromium.org>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
In-Reply-To: <1331121050-17857-7-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org> <1331121050-17857-7-git-send-email-djkurtz@chromium.org>
Date: Wed, 07 Mar 2012 12:12:29 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  7 Mar 2012 19:50:47 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
> Return -ENXIO if a device NAKs a transaction.
> 
> Note: We should return -ETIMEDOUT, too if the transaction times out,
> however, that error path is currently handled by the 'bit-bang fallback'.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>

Can you clarify what the rule is if an error is detected part-way
through a xfer?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
