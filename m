Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab2LGMFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 07:05:01 -0500
Received: from mga01.intel.com ([192.55.52.88]:43847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab2LGMFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 07:05:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,237,1355126400"; 
   d="scan'208";a="258653968"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Tim Gardner <tim.gardner@canonical.com>, linux-kernel@vger.kernel.org
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tim Gardner <tim.gardner@canonical.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH linux-next] i915: intel_set_mode: Reduce stack allocation from 500 bytes to 2 pointers
In-Reply-To: <6c3329$7hpdt5@orsmga002.jf.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1354815755-83271-1-git-send-email-tim.gardner@canonical.com> <87zk1qm6cd.fsf@intel.com> <6c3329$7hpdt5@orsmga002.jf.intel.com>
User-Agent: Notmuch/0.14+142~gf454854 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 07 Dec 2012 14:05:35 +0200
Message-ID: <87wqwum5io.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Dec 2012, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Fri, 07 Dec 2012 13:47:46 +0200, Jani Nikula <jani.nikula@linux.intel.com> wrote:
>> 
>> On Thu, 06 Dec 2012, Tim Gardner <tim.gardner@canonical.com> wrote:
>> > +	if (!saved_mode) {
>> > +		pr_err("i915: Could not allocate saved display mode.\n");
>> 
>> Please use DRM_ERROR().
>
> Truthfully neither, but join the growing petition to get real errorcodes
> back to userspace!

Heh, agreed, but in the mean time (i.e. before hell freezes over) I
think we should prefer DRM_ERROR over pr_err for consistency.

Jani.
