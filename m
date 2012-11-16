Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2KPRmQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:42:16 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:25200 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233Ab2KPRmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:42:15 -0500
Date: Fri, 16 Nov 2012 17:42:14 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Shan Wei <shanwei88@gmail.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v3 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
In-Reply-To: <20121116164337.GD3270@linux.vnet.ibm.com>
Message-ID: <0000013b0a505095-87cdf6aa-4e22-4439-9fe2-5c93044077ff-000000@email.amazonses.com>
References: <50A1A7E8.4010802@gmail.com> <50A5FA32.4000903@gmail.com> <20121116164337.GD3270@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 16 Nov 2012, Paul E. McKenney wrote:

> If you either show me some significant performance benefits or get me
> an independent Tested-by, in both cases on a range of hardware (e.g.,
> x86 on the one hand and ARM or Power on the other), then I will queue it.

Just putting the code generated for x86 before and after side
by side would be enough to convince you I think.

> I wasn't prioritizing this one very high because it does not appear
> to be on any sort of fastpath.  If I am wrong about that, then you
> have a good performance-benefit case, right?  ;-)

I do not think this needs to be a priority item. Just stick it in the tree
somewhere to merge for the next merge period.

