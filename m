Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1GUOoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:44:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:54117 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1GUOoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:44:32 -0400
Message-Id: <aefc95$suc0v@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,240,1309762800"; 
   d="scan'208";a="30355487"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: TV output not detected on Intel 965GM
To: Keith Duthie <keith@no.net.nz>, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
In-Reply-To: <CAFPheENr=yOgVqPfrD9qb2qpHzDpB1DOFRmunrZyNs4bkMW8wA@mail.gmail.com>
References: <CAFPheENr=yOgVqPfrD9qb2qpHzDpB1DOFRmunrZyNs4bkMW8wA@mail.gmail.com>
Date: Thu, 21 Jul 2011 15:44:27 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 02:11:32 +1200, Keith Duthie <keith@no.net.nz> wrote:
> Hi,
> 
> Since 44834a67c0082e2cf74b16be91e49108b1432d65 (aka 2.6.36-rc3-00056),
> my Intel 965GM based notebook has stopped detecting the TV output in
> X.

The fundamental issue would then appear to be that your BIOS is not
listing the TV out as present.  In which case you will want to attach
the vbios (intel-gpu-tools/tools/intel_bios_dumper) and also the opregion
(/sys/kernel/debug/dri/0/i915_opregion). And we can see what the
difference is. The answer may well very possibly be: update your BIOS.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
