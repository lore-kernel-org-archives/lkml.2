Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab0JDUqq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:46:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:38188 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757206Ab0JDUqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:46:45 -0400
Message-Id: <8u3s8d$jp78ts@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,280,1283756400"; 
   d="scan'208";a="663987132"
Date: Mon, 04 Oct 2010 21:46:38 +0100
To: Thomas Meyer <thomas@m3y3r.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm:init_ring_common] *ERROR* render ring head not reset to zero
References: <201010042231.20320.thomas@m3y3r.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <201010042231.20320.thomas@m3y3r.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010 22:31:20 +0200, Thomas Meyer <thomas@m3y3r.de> wrote:
> [    0.556247] [drm:init_ring_common] *ERROR* render ring head not reset to zero ctl 00000000 head 02001000 tail 00000000 start 02001000
> [    0.556320] [drm:init_ring_common] *ERROR* render ring head forced to zero ctl 00000000 head 00000000 tail 00000000 start 02001000
> 
> Bug or feature?

Hardware feature, software bug. Could also be a feature of the software to
report a hardware bug...

At any rate, it shouldn't be happening and you are not alone at finding
such errors in your logs.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
