Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab0CQPWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:22:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:45350 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab0CQPWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:22:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,657,1262592000"; 
   d="scan'208";a="501379149"
Subject: Re: [patch 2/2] x86,pat Convert memtype_lock into an rw_lock.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "holt@sgi.com" <holt@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
In-Reply-To: <20100315132110.834268286@gulag1.americas.sgi.com>
References: <20100315132103.228021253@gulag1.americas.sgi.com>
	 <20100315132110.834268286@gulag1.americas.sgi.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 17 Mar 2010 08:21:23 -0800
Message-Id: <1268842883.2696.10.camel@sbs-t61>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 06:21 -0700, holt@sgi.com wrote:
> Convert the memtype_lock from a spin_lock to an rw_lock.  The first
> version of my patch had this and it did improve performance for fault
> in times.  The atomic page flags patch (first in the series) improves
> things much greater for ram pages.  This patch is to help the other pages.
> 

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

X86 folks, can you please queue  both these patches if you don't have
any objections.

thanks,
suresh

