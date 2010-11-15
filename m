Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab0KORqV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:46:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:52859 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772Ab0KORqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:46:17 -0500
Subject: Re: [RFC][PATCH v2 4/7] taskstats: Add per task steal time
 accounting
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org,
        "jeremy.fitzhardinge" <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <20101115184206.4463fd05@mschwide.boeblingen.de.ibm.com>
References: <20101111170352.732381138@linux.vnet.ibm.com>
	 <20101111170815.024542355@linux.vnet.ibm.com>
	 <1289677083.2109.167.camel@laptop>
	 <20101115155057.15f3be35@mschwide.boeblingen.de.ibm.com>
	 <1289833883.2109.494.camel@laptop>
	 <20101115184206.4463fd05@mschwide.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 15 Nov 2010 18:45:52 +0100
Message-ID: <1289843152.2109.515.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-15 at 18:42 +0100, Martin Schwidefsky wrote:
> I do not know if that is true for
> ia64 as well which is the third architecture with VIRT_CPU_ACCOUNTING=y. 

IIRC ia64 uses VIRT_CPU_ACCOUNTING to get high-res task accounting, it
was done before CFS came around and used ns based accounting for all
tasks.


