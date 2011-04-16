Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1DPGHk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 02:07:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:39902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1DPGHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 02:07:39 -0400
Message-Id: <1bdc18$k8bgo3@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="679854851"
Date: Sat, 16 Apr 2011 07:07:35 +0100
To: wzab@ise.pw.edu.pl, linux-kernel@vger.kernel.org
Subject: Re: i915 drm GPU hung errors with kernel 2.6.38.2 on  82865G chipset
References: <4DA8B3A7.3010807@ise.pw.edu.pl>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <4DA8B3A7.3010807@ise.pw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011 23:07:51 +0200, wzab <wzab@ise.pw.edu.pl> wrote:
> Today I have experienced two "GPU hungs" on machine with 82865G chipset 
> working with 2.6.38.2 kernel
> In the /var/log/syslog I have found the following errors:
> 
> Apr 15 22:50:51 wzab kernel: [drm:i915_hangcheck_elapsed] *ERROR* 
> Hangcheck timer elapsed... GPU hung

As Bruno said there is a /sys/kernel/debug/dri/0/i915_error_state file
that contains a GPU dump at the time of the error which often contains the
vital clue at to what went wrong. If you can also think back to what was
happening on the machine at the time of the hang, that can also help
identify the trigger and the suspect code.

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
