Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab1ALXjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 18:39:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab1ALXjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 18:39:03 -0500
From: Thomas Renninger <trenn@suse.de>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 4/9] cpuidle: Introduce .abbr (abbrevation) for cpuidle states
Date: Thu, 13 Jan 2011 00:39:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-perf-users@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
        j-pihet@ti.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <1294396190-23031-1-git-send-email-trenn@suse.de> <201101121437.51122.trenn@suse.de> <alpine.LFD.2.02.1101121705130.19754@x980>
In-Reply-To: <alpine.LFD.2.02.1101121705130.19754@x980>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101130039.19519.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 January 2011 23:25:12 Len Brown wrote:
> > > If the display tools can only handle 3 characters,
> > > then why not have them simply use the 1st 3 characters
> > > of the existing name field?
> 
> > You mean use:
> > C3 NHM
> > instead of
> > NHM-C3
> > for intel_idle?
> 
> Yes.
> is there a reason that would be a problem?
A much more elegant solution came to my mind:
I'll rewrite the perf timechart patch to do:
Title:   C-stateName1 [1] , C-stateName2 [2]
and later I will refer to the states by 1, 2, ...
Eventually a:
Description:
[1] C-stateDescription1
[2] C-stateDescription2
...
can be put somewhere as well.

Please ignore this patch.

Stupid that I didn't think of that in the first place.

Thanks,

   Thomas
