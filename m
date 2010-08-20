Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0HTAUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 20:20:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:41083 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab0HTAUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 20:20:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,236,1280732400"; 
   d="scan'208";a="546990015"
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1282208064.1926.4519.camel@laptop>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
	 <1282185811.11858.92.camel@minggr.sh.intel.com>
	 <1282208064.1926.4519.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 08:21:15 +0800
Message-ID: <1282263675.11858.111.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 16:54 +0800, Peter Zijlstra wrote:
> On Thu, 2010-08-19 at 10:43 +0800, Lin Ming wrote:
> > Sorry that I have no good idea how to export the various tracepoints
> > events automatically, so this work will take time.
> > 
> Well, we could start with just he hardware bits and leave the tracepoint
> bits for later, right?

Right. I'll update the patches.


