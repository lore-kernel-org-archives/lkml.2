Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0KYQeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 11:34:15 -0500
Received: from canuck.infradead.org ([134.117.69.58]:49446 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab0KYQeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 11:34:14 -0500
Subject: Re: [RFC][PATCH 2/8] perf, arch: Use early_initcall() for all arch
 pmu implementations
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        davem <davem@davemloft.net>, Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>, Don Zickus <dzickus@redhat.com>
In-Reply-To: <1290702150.2059.10.camel@e102144-lin.cambridge.arm.com>
References: <20101117221730.002627458@chello.nl>
	 <20101117222056.040309789@chello.nl>  <1290680713.2145.18.camel@laptop>
	 <1290696476.2145.46.camel@laptop>
	 <1290702150.2059.10.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 17:34:12 +0100
Message-ID: <1290702852.2145.60.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 16:22 +0000, Will Deacon wrote:
> What tree/branch are these patches taken against? They don't seem
> to apply against -rc3 or tip/master.

tip/master + my quilt queue

>  Anyway, I currently have some
> pending patches to split up the monolithic perf_event.c we have for ARM
> so that different PMU implementations can live in different files (in
> the same way that x86 does it). This might mean that your initcall patch
> no longer applies because it will be a couple of thousand lines higher
> up in the file. 

That's ok, I'm sure we can sort that out when I've got stuff working ;-)
