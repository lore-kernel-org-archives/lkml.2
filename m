Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab0IMJTB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 05:19:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41913 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0IMJS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 05:18:59 -0400
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, dhowells <dhowells@redhat.com>,
        Russell King <rmk@arm.linux.org.uk>, Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        davem <davem@davemloft.net>, Linux-Arch <linux-arch@vger.kernel.org>
In-Reply-To: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
References: <1284360648.3269.115.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 13 Sep 2010 11:18:40 +0200
Message-ID: <1284369520.2275.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 14:50 +0800, Huang Ying wrote:
> 
> In order for other NMI context users that want to run things from
> hard-IRQ context, extract the perf_event callback mechanism.
> 
> Huang Ying: some fixes
> 
> This patch is only tested on x86 platform.


Anybody willing to take a peek at this?
