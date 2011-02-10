Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab1BJDq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:46:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:9124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab1BJDq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:46:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,450,1291622400"; 
   d="scan'208";a="386686311"
Date: Wed, 9 Feb 2011 19:46:56 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        James Bottomley <James.Bottomley@suse.de>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
Message-ID: <20110210034656.GA22753@gargoyle.amr.corp.intel.com>
References: <1297300864.2645.128.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297300864.2645.128.camel@schen9-DESK>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>

Patch looks good to me. Thanks Tim.

I expect this will also improve other pm-qos users, but of course they
are likely not as frequently used as the idle governour.

(and before anyone makes jokes about optimizing the idle loop: idle 
latency is very important for workloads with lots of wakeups out of
idle)

-Andi
