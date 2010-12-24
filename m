Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0LWN5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:57:38 -0500
Received: from mga02.intel.com ([134.134.136.20]:15640 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493Ab0LWN5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:57:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,219,1291622400"; 
   d="scan'208";a="690179406"
Date: Thu, 23 Dec 2010 22:06:27 -0500
From: Youquan Song <youquan.song@linux.intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Youquan Song <youquan.song@intel.com>, davej@redhat.com,
        cpufreq@vger.kernel.org, venki@google.com, arjan@linux.intel.com,
        lenb@kernel.org, suresh.b.siddha@intel.com, kent.liu@intel.com,
        chaohong.guo@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 0/6] cpufreq: Add sampling window to enhance ondemand
	governor power efficiency
Message-ID: <20101224030627.GA9850@linux-youquan.bj.intel.com>
References: <1293085424-18212-1-git-send-email-youquan.song@intel.com> <20101223110020.GC18363@comet.dominikbrodowski.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101223110020.GC18363@comet.dominikbrodowski.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Interesting approach, but seems to be quite different from what "ondemand"
> does at the moment. And, as David Niemi pointed out, it seems to be more
> Intel-specific. Therefore, what do you think about adding this different
> algorithm as a different governor, and keep the "ondemand" algorithm more or
> less as it is?

Good suggestion! I will write a different governor soon if nobody
oppose.

Thanks
-Youquan
