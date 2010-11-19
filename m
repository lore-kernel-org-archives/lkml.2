Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab0KSVmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:42:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:56784 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab0KSVma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:42:30 -0500
Message-Id: <5b55a1$indcgc@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,226,1288594800"; 
   d="scan'208";a="628535820"
Date: Fri, 19 Nov 2010 21:42:10 +0000
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: DVI/EDID broken with Intel i945 graphics and 2.6.37-rc2
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20101119075427.GA7002@mac.home>
References: <20101116184914.GA15794@mac.home> <b9dded$h40vqf@orsmga002.jf.intel.com> <20101119075427.GA7002@mac.home>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010 08:54:27 +0100, Tino Keitel <tino.keitel@tikei.de> wrote:
> On Wed, Nov 17, 2010 at 10:20:09 +0000, Chris Wilson wrote:
> 
> [...]
> 
> > An alternative is to force detection, ie change the detect(analog, false)
> > to true.
> 
> Hi,
> 
> this didn't help either.

If we didn't even hit the additional printks, then I am no longer even
sure what is going on here... Can you add drm.debug=0xe to your boot line
and attach the dmesg from boot?

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
