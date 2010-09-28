Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0I1ISC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:18:02 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:58581 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab0I1IR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:17:59 -0400
Date: Tue, 28 Sep 2010 13:47:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: holzheu@linux.vnet.ibm.com, Shailabh Nagar <nagar1234@in.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise accounting
Message-ID: <20100928081732.GB4128@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1285249681.1837.28.camel@holzheu-laptop>
 <20100923131136.356075f4.akpm@linux-foundation.org>
 <1285319415.2179.116.camel@holzheu-laptop>
 <20100924115002.fcb4385a.akpm@linux-foundation.org>
 <1285579127.2116.62.camel@holzheu-laptop>
 <20100927130256.5d9a3db8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100927130256.5d9a3db8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2010-09-27 13:02:56]:

> > Good point. It is not really necessary. I started development using the
> > netlink code. Therefore I first added the new command in the netlink
> > code. I also thought, it would be a good idea to provide all netlink
> > commands over the procfs interface to be consistent.
> 
> Maybe we should have delivered taskstats over procfs from day one.
>

The intention was to provide taskstats over a scalable backend to deal
with a large amount of data, including exit notifications. We provided
some information like blkioi delay data on proc, but not the whole structure. 

-- 
	Three Cheers,
	Balbir
