Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab2H2BFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 21:05:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59437 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2H2BFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 21:05:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120828170734.GT2961@linux.vnet.ibm.com>
References: <1345128138.29668.42.camel@twins>
	<CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
	<1345139199.29668.46.camel@twins>
	<CADZ9YHgNhTGWicX0kFfrNoL17JkxfZcXryqqa-wHLVLh05SvAg@mail.gmail.com>
	<1345454817.23018.27.camel@twins>
	<20120820162657.GI2435@linux.vnet.ibm.com>
	<20120827184435.GA13883@linux.vnet.ibm.com>
	<CADZ9YHi-DGd71jxQpYyRfVUqdr-ks-znSeCtcBAccL7wRd3r5g@mail.gmail.com>
	<20120828134206.GH2961@linux.vnet.ibm.com>
	<CADZ9YHhXspOy9cy--cPqzaZYssDjgwRPztU=pg-Rfj5g2aXDiw@mail.gmail.com>
	<20120828170734.GT2961@linux.vnet.ibm.com>
Date: Wed, 29 Aug 2012 07:05:07 +0600
Message-ID: <CADZ9YHj9KmWU+A9MnNPDEPsEjzb2_ArCLFvt6d+fsGgXmpLfaQ@mail.gmail.com>
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU goes down.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/28/12, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>
> OK, but I thought that Peter said that ->nr_uninterruptible was
> meaningful only when summed across all CPUs.  If that is the case,
> it shouldn't matter where the counts are moved.
>
Yes, right. But, nr_uninterruptible is also use to calculate delta.
Please see calc_load_fold_active().

Thanks,
Rakib.
