Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1BJUh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 15:37:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:44038 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756327Ab1BJUh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 15:37:26 -0500
Message-Id: <1bdc18$ji32t3@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'208";a="656509859"
Date: Thu, 10 Feb 2011 20:37:23 +0000
To: chris2553@googlemail.com
Subject: Re: [PATCH] drm/i915: Handle the no-interrupts case for UMS by polling
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <201101231128.22951.chris2553@googlemail.com> <201101231538.41929.chris2553@googlemail.com> <0d30dc$kr9795@orsmga001.jf.intel.com> <201102101958.12842.chris2553@googlemail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201102101958.12842.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011 19:58:12 +0000, Chris Clayton <chris2553@googlemail.com> wrote:
> OK, I haven't raised the bug report yet, but I now know how to create it - 
> reboot via kexec which is what I must have done when I built and installed the 
> kernel to test your patches. I guess not having booted via the bios is leaving 
> the card in an odd state. Do you care any more, please? If you do, I'll open 
> the bug report. 

Please, I think we left my very small field of expertise so a bug may help
attract the attention of those in the know...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
