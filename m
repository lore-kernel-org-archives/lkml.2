Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2IGTPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 15:15:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:41451 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283Ab2IGTPE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 15:15:04 -0400
Message-ID: <1347045298.2124.8.camel@twins>
Subject: Re: [PATCH 1/3] perf: use hrtimer for event multiplexing
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com, robert.richter@amd.com
Date: Fri, 07 Sep 2012 21:14:58 +0200
In-Reply-To: <CABPqkBSQwduG2bwz0DYP1HPf+4_SQOMhxTBSnKSX-CmATBa93A@mail.gmail.com>
References: <1347028169-1983-1-git-send-email-eranian@google.com>
	 <1347028169-1983-2-git-send-email-eranian@google.com>
	 <1347032350.18408.88.camel@twins>
	 <CABPqkBT=2H5WuWZ+uFq39XTTxniVvT6tEuaYDHvaV2VSbjBPDQ@mail.gmail.com>
	 <1347044931.2124.5.camel@twins>
	 <CABPqkBSQwduG2bwz0DYP1HPf+4_SQOMhxTBSnKSX-CmATBa93A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 21:10 +0200, Stephane Eranian wrote:
> 
> That's true. I started modifying my code to implement your suggestion.
> We'll see how it goes. Then we would have to export that mux interval
> via sysfs for each PMU. 

Indeed. Thanks!
