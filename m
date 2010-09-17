Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab0IQMi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 08:38:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0IQMi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 08:38:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1284627425.2754.434.camel@yhuang-dev>
References: <1284627425.2754.434.camel@yhuang-dev> <1284360648.3269.115.camel@yhuang-dev.sh.intel.com> <20100913123213.76b1b5fa@mschwide.boeblingen.de.ibm.com> <1284377790.2275.212.camel@laptop> <1284528590.2256.135.camel@yhuang-dev.sh.intel.com> <1284539320.3764.266.camel@twins>
To: Huang Ying <ying.huang@intel.com>
Cc: dhowells@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        paulus <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Russell King <rmk@arm.linux.org.uk>,
        Kyle McMartin <kyle@mcmartin.ca>, davem <davem@davemloft.net>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH -tip -v4] irq_work: generic hard-irq context callbacks
Date: Fri, 17 Sep 2010 13:37:40 +0100
Message-ID: <5866.1284727060@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying <ying.huang@intel.com> wrote:

> Where can I find latest FRV cross compiler workable for Linux kernel?

I'm trying to get a fairly current one put up on FTP somewhere.

David
