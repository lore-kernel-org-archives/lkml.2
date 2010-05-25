Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab0EYMK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:10:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38319 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755010Ab0EYMK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:10:56 -0400
Date: Tue, 25 May 2010 17:40:24 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: tj@kernel.org, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make sure timers have migrated before killing
	migration_thread
Message-ID: <20100525121024.GA10471@amitarora.in.ibm.com>
References: <20100519090557.GA15237@amitarora.in.ibm.com> <1274261515.5605.10423.camel@twins> <20100524095951.GA17680@amitarora.in.ibm.com> <1274787095.5882.949.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274787095.5882.949.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 01:31:35PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-05-24 at 15:29 +0530, Amit K. Arora wrote:
> > 
> > Thus, since above race can never happen, is there any other issue with
> > this patch ?
> 
> It doesn't seem to apply nicely...

Hi Peter,

This patch was built on top of 2.6.34, where it applies cleanly. I
checked the git tree and the cpu_stop patchset from Tejun has changed
this code quite much (commit 969c79215a35b06e5e3efe69b9412f858df7856c).

The change is now required in cpu_stop_cpu_callback() in stop_machine.c.
Will post it soon. Thanks!

--
Regards,
Amit Arora
