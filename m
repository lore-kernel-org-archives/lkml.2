Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269Ab2EVRod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:44:33 -0400
Received: from mga03.intel.com ([143.182.124.21]:29004 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab2EVRob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:44:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146363978"
Subject: Re: [PATCH 2/2] x2apic, cluster: use all the members of one cluster
 specified in the smp_affinity mask for the interrupt desintation
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Ingo Molnar <mingo@kernel.org>, agordeev@redhat.com, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Tue, 22 May 2012 10:42:57 -0700
In-Reply-To: <20120522173922.GC1442@moon>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <1337644682-19854-2-git-send-email-suresh.b.siddha@intel.com>
	 <20120522070428.GA15738@gmail.com>
	 <1337707275.1997.184.camel@sbsiddha-desk.sc.intel.com>
	 <20120522173922.GC1442@moon>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1337708577.1997.187.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 21:39 +0400, Cyrill Gorcunov wrote:
> Suresh, should not we tune up es7000_cpu_mask_to_apicid code to return
> apicid with a cluster number and ORed logical apicid part as done for
> x2apic, or the way it resturns apicid now was done by a purpose?

Don't know. Those are very old platforms. Not worth tuning them IMHO.

thanks,
suresh

