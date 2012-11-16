Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2KPSKU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 13:10:20 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:40220 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab2KPSKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 13:10:19 -0500
Date: Fri, 16 Nov 2012 10:09:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: Shan Wei <shanwei88@gmail.com>, dipankar@in.ibm.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v3 6/9] rcu: use __this_cpu_read helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
Message-ID: <20121116180956.GE3270@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50A1A7E8.4010802@gmail.com>
 <50A5FA32.4000903@gmail.com>
 <20121116164337.GD3270@linux.vnet.ibm.com>
 <0000013b0a505095-87cdf6aa-4e22-4439-9fe2-5c93044077ff-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013b0a505095-87cdf6aa-4e22-4439-9fe2-5c93044077ff-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111618-9360-0000-0000-00000CE282FF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 05:42:14PM +0000, Christoph Lameter wrote:
> 
> On Fri, 16 Nov 2012, Paul E. McKenney wrote:
> 
> > If you either show me some significant performance benefits or get me
> > an independent Tested-by, in both cases on a range of hardware (e.g.,
> > x86 on the one hand and ARM or Power on the other), then I will queue it.
> 
> Just putting the code generated for x86 before and after side
> by side would be enough to convince you I think.

If accompanied by similar before/after code for ARM or Power, sure.

							Thanx, Paul

> > I wasn't prioritizing this one very high because it does not appear
> > to be on any sort of fastpath.  If I am wrong about that, then you
> > have a good performance-benefit case, right?  ;-)
> 
> I do not think this needs to be a priority item. Just stick it in the tree
> somewhere to merge for the next merge period.
> 

