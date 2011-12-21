Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1LUVl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:41:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:52455 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1LUVl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:41:26 -0500
Message-ID: <1324503667.17070.7.camel@twins>
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vince@deater.net>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Dec 2011 22:41:07 +0100
In-Reply-To: <alpine.DEB.2.02.1112211622560.16411@pianoman.cluster.toy>
References: <20111121145114.049265181@chello.nl>
	  <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu>
	 <1324472337.10752.11.camel@twins>
	 <alpine.DEB.2.02.1112210959540.10098@pianoman.cluster.toy>
	 <alpine.DEB.2.02.1112211622560.16411@pianoman.cluster.toy>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 16:32 -0500, Vince Weaver wrote:

> * One, is it possible to detect at runtime that rdpmc() is supported?  
>   Maybe a field in the mmap'd buffer that can be read?

Ingo suggested a similar thing, will implement (although Christmas might
interfere with delivery timelines etc..).

> * Second, if I try a start / run 100M instructions / read
>   and measure retired instructions I get:
>       281474977711543 instructions
>   This is 0x10000000f45b7 which is 1<<48 + 100M.  I guess an artifact
>   of how the counters are set up?  Is it possible to have this start
>   at 0?  

Its supposed to be 0 based, clearly I messed up something and need to go
figure out what. Thanks for reporting.
