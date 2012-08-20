Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2HTTW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:22:57 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:6772 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753752Ab2HTTWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:22:55 -0400
Date: Mon, 20 Aug 2012 19:22:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Arjan van de Ven <arjan@linux.intel.com>, Alex Shi <alex.shi@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
In-Reply-To: <20120820155203.GB29974@srcf.ucam.org>
Message-ID: <00000139457cd7a4-6dc13b06-c387-4c5e-9297-121c9cde6c39-000000@email.amazonses.com>
References: <5028F12C.7080405@intel.com> <20120815161911.GA14534@srcf.ucam.org> <502C7F24.6020900@intel.com> <502CFC41.1030501@linux.intel.com> <0000013944b80714-c594cc1e-de63-4901-9aa7-0b5a3d8629e5-000000@email.amazonses.com>
 <20120820155203.GB29974@srcf.ucam.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Matthew Garrett wrote:

> On Mon, Aug 20, 2012 at 03:47:54PM +0000, Christoph Lameter wrote:
>
> > So please make sure that there are obvious and easy ways to switch this
> > stuff off or provide "low latency" know that keeps the system from
> > assuming that idle time means that full performance is not needed.
>
> That seems like an issue for cpuidle, not the scheduler. Does pm_qos not
> already do what you want?

Dont know. A simple solution is not to compile power management into the
kernel.

