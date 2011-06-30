Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab1F3FLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:11:41 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:42014 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1F3FLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:11:34 -0400
Date: Thu, 30 Jun 2011 10:41:23 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com, thomas.abraham@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110630051123.GD12667@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110629130038.GA7909@in.ibm.com>
 <1309367184.11430.594.camel@nimitz>
 <20110629174220.GA9152@in.ibm.com>
 <1309370342.11430.604.camel@nimitz>
 <m2y60k1jqj.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2y60k1jqj.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 29, 2011 at 01:11:00PM -0700, Andi Kleen wrote:
> Dave Hansen <dave@linux.vnet.ibm.com> writes:
> >
> > It's also going to be a pain to track kernel references.  On x86, our
> 

As Vaidy mentioned, we are only looking at memory being either allocated
or free, as a way to evacuate it. Tracking memory references, no doubt,
is a difficult proposition and might involve a lot of overhead.
 
> Even if you tracked them what would you do with them?
>
> It's quite hard to stop using arbitary kernel memory (see all the dancing
> memory-failure does) 
> 
> You need to track the direct accesses to user data which happens
> to be accessed through the direct mapping.
> 
> Also it will be always unreliable because this all won't track DMA.
> For that you would also need to track in the dma_* infrastructure,
> which will likely get seriously expensive.
> 

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs,
Bangalore, India
