Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1LMW2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:28:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:18291 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab1LMW2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:28:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101856728"
Date: Tue, 13 Dec 2011 14:27:59 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] DEBUGFS: Automatically create parents for debugfs
 files v2
Message-ID: <20111213222759.GB7633@tassilo.jf.intel.com>
References: <1323812733-7520-1-git-send-email-andi@firstfloor.org>
 <20111213222256.GD2618@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213222256.GD2618@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Andi, is it possible to do say kstrdup or something instead of

It's possible, just would add complexity with an additional
error path.

> variable-size array in fn[strlen(name) + 1] ? As far as I remember
> we already had some warnings with them at least in perf land (or
> trace land). Or I miss something?

Not aware of any problems with tracing or perf. I like them at least.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
