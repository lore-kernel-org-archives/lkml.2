Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599Ab1ISNdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:33:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:58282 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab1ISNdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:33:10 -0400
Message-Id: <aefc95$1fih8n@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="49890583"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [BUG] i915 crashes X Server Constantly on Linux-3.1-rc4 to .rc6
To: Tarkan Erimer <tarkan.erimer@f-secure.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4E773E65.5040809@f-secure.com>
References: <4E770FF5.8030207@f-secure.com> <aefc95$1fgrb6@orsmga001.jf.intel.com> <4E773E65.5040809@f-secure.com>
Date: Mon, 19 Sep 2011 14:33:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 16:06:45 +0300, Tarkan Erimer <tarkan.erimer@f-secure.com> wrote:
Non-text part: multipart/mixed
> I did a bit more digging and found out that it mostly happens when 
> trying to open some flash based sites on Firefox and Chromium. I've 
> attached Xorg.log, but it seems like no errors related to these crashes. 
> But kdm.log has some interesting error messages that may be useful. I've 
> attached kdm.log as well.

That looks remarkably consistent. Can you please do a quick
addr2line -e /usr/lib64/xorg/modules/drivers/intel_drv.so 0x3e7ce 0x44d34

Also do you know which particular site triggers the issue?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
