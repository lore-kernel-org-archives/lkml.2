Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab0HTKEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:04:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:50732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0HTKEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:04:51 -0400
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100820081605.GD17551@elte.hu>
References: <20100804184806.GL26154@erda.amd.com>
	 <20100804192634.GG5130@lenovo> <20100806065203.GR26154@erda.amd.com>
	 <20100806142131.GA1874@redhat.com> <20100809194829.GB26154@erda.amd.com>
	 <20100817152225.GQ26154@erda.amd.com> <1282214753.1926.4669.camel@laptop>
	 <20100819141240.GO4879@redhat.com> <1282228033.2605.204.camel@laptop>
	 <20100820015017.GA4879@redhat.com>  <20100820081605.GD17551@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 12:04:11 +0200
Message-ID: <1282298651.2605.769.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 10:16 +0200, Ingo Molnar wrote:
> 
> 
> Please someone send the final version with a changelog, with all the acks and 
> tested-by's added, so that i can send it Linuswards. 

I've got two patches queued, one from Robert (with a slight
modification, which removes a goto) and one from myself converting the
intel and p4 irq handler.

They're available at:

  programming.kicks-ass.net/sekrit/patches.tar.bz2

I did add Tested-by tags, although I suspect its not the exact same bits
Don tested..
