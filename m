Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1ADOfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:35:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:19399 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab1ADOff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:35:35 -0500
Message-Id: <849307$b0n4jp@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,272,1291622400"; 
   d="scan'208";a="369857145"
Date: Tue, 04 Jan 2011 14:35:26 +0000
To: Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.37-rc8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110104142604.GA6591@ucw.cz>
References: <AANLkTi=-dNeeDjcSoznKtwcaNyw1mMXSqepFY89R2i+2@mail.gmail.com> <20110104142604.GA6591@ucw.cz>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011 15:26:04 +0100, Pavel Machek <pavel@ucw.cz> wrote:
> I still see blank screen on thinkpad x60... but so do I on 2.6.36 with
> same config, so maybe it is just tricky to configure?

Old bug? I thought we had KMS on 945 pretty well understood by now. Care
to attach the dmesg with drm.debug=0xe? And to check against linus/master
for the most recent regression fixes.
Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
