Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab0KOQES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:04:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:34750 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab0KOQER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:04:17 -0500
Subject: Re: [RFC][PATCH v2 5/7] taskstats: Improve cumulative CPU time
 accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
In-Reply-To: <20101115165521.21baac60@mschwide.boeblingen.de.ibm.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170815.404670062@linux.vnet.ibm.com>
	 <20101113183810.GA9021@redhat.com>
	 <20101115165521.21baac60@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 17:03:56 +0100
Message-ID: <1289837036.2109.501.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 16:55 +0100, Martin Schwidefsky wrote:
>  What we want is a low-overhead tool that precisely shows
> where the cpu spent its time (or didn't because of steal time). The
> granularity target is tenths of microseconds, something that should be
> possible with decent hardware. 

To what purpose? 

