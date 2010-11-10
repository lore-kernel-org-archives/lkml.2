Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0KJHqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 02:46:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:57832 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752962Ab0KJHqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 02:46:43 -0500
Message-Id: <0d30dc$k4n8nm@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,177,1288594800"; 
   d="scan'208";a="676045558"
Date: Wed, 10 Nov 2010 07:46:40 +0000
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [bisected] i915 regression in post 2.6.36 kernels
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de>
References: <201011100802.20332.johannes.hirte@fem.tu-ilmenau.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010 08:02:19 +0100, Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de> wrote:
> With the latest kernel, I don't get any windows in KDE displayed. After
> starting kdm, I get the background picture and the mouse cursor but not the
> login window. I can login blindly and a ps on console shows me that the
> expected KDE processes are started but still nothing is displayed. 
> I've bisected this to:
> 
> 5c12a07e8073295ce8b57a822f811ac34e4f8420 is the first bad commit
> commit 5c12a07e8073295ce8b57a822f811ac34e4f8420
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Sep 22 11:22:30 2010 +0100
> 
>     drm/i915: Drop ring->lazy_request
>     
>     We are not currently using it as intended, so remove the complication.
> 
>     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

May I ask you to recheck your bisection, since that was later reverted.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
