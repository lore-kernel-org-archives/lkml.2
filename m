Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab1BYIzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 03:55:07 -0500
Received: from mga01.intel.com ([192.55.52.88]:5812 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932342Ab1BYIzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 03:55:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,224,1297065600"; 
   d="scan'208";a="661377213"
Subject: Re: [PATCH -tip] perf: x86, add SandyBridge support
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110224165705.GA15498@elte.hu>
References: <1298555968.2220.15.camel@localhost>
	 <1298556237.2220.19.camel@localhost>  <20110224165705.GA15498@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 16:55:19 +0800
Message-ID: <1298624119.2835.87.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-25 at 00:57 +0800, Ingo Molnar wrote:
> * Lin Ming <ming.m.lin@intel.com> wrote:
> 
> > Adds SandyBridge support to perf.
> 
> Wondering, have you tested things like PEBS? You can do it via:
> 
> 	perf record -e instructions:p -a sleep 10
> 	perf top -e instructions:p
> 
> ('p' stands for 'precise')

Let me do more PEBS tests...

> 
> Also, please list known limitations in the changelog.

OK. 

> 
> Thanks,
> 
> 	Ingo


