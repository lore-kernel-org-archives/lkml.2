Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1FJRUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:20:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:54739 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755635Ab1FJRUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:20:15 -0400
Date: Fri, 10 Jun 2011 10:19:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Kyungmin Park <kmpark@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, svaidy@linux.vnet.ibm.com,
        thomas.abraham@linaro.org
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110610171939.GE2230@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110528005640.9076c0b1.akpm@linux-foundation.org>
 <20110609185259.GA29287@linux.vnet.ibm.com>
 <BANLkTinxeeSby_+tta8EhzCg3VbD6+=g+g@mail.gmail.com>
 <20110610151121.GA2230@linux.vnet.ibm.com>
 <20110610155954.GA25774@srcf.ucam.org>
 <20110610165529.GC2230@linux.vnet.ibm.com>
 <20110610170535.GC25774@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110610170535.GC25774@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 06:05:35PM +0100, Matthew Garrett wrote:
> On Fri, Jun 10, 2011 at 09:55:29AM -0700, Paul E. McKenney wrote:
> > On Fri, Jun 10, 2011 at 04:59:54PM +0100, Matthew Garrett wrote:
> > > For the server case, the low hanging fruit would seem to be 
> > > finer-grained self-refresh. At best we seem to be able to do that on a 
> > > per-CPU socket basis right now. The difference between active and 
> > > self-refresh would seem to be much larger than the difference between 
> > > self-refresh and powered down.
> > 
> > By "finer-grained self-refresh" you mean turning off refresh for banks
> > of memory that are not being used, right?  If so, this is supported by
> > the memory-regions support provided, at least assuming that the regions
> > can be aligned with the self-refresh boundaries.
> 
> I mean at the hardware level. As far as I know, the best we can do at 
> the moment is to put an entire node into self refresh when the CPU hits 
> package C6.

But this depends on the type of system and CPU family, right?  If you
can say, which hardware are you thinking of?  (I am thinking of ARM.)

							Thanx, Paul
