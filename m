Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab2IQOMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 10:12:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:52411 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756205Ab2IQOMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 10:12:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,435,1344236400"; 
   d="scan'208";a="206186151"
Date: Mon, 17 Sep 2012 22:15:15 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Rik van Riel <riel@redhat.com>
Cc: Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, arjan@linux.intel.com, lenb@kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH V2 1/3] x86,idle: Quickly notice prediction failure for
	repeat mode
Message-ID: <20120918021514.GA6997@linux-youquan.bj.intel.com>
References: <1347933209-25939-1-git-send-email-youquan.song@intel.com> <1347933209-25939-2-git-send-email-youquan.song@intel.com> <50572CD1.700@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50572CD1.700@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could I convince you to try out my variation on
> detect_repeating_intervals? :)
>
> http://people.redhat.com/riel/cstate/cstate-stddev-converge.patch
>
> I suspect that small change might help your code adapt to changed
> conditions even faster.

Yes. of course. your patch of cstate-stddev-converge is a good point by
filter some noise first, then calculate further. I will try to integrate
the patch to my patchset, then ask you review tomorrow. 

Thanks
-Youquan

