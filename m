Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0HPOhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:37:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:52843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab0HPOhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:37:42 -0400
Subject: Re: [PATCH] perf, x86: try to handle unknown nmis with running
 perfctrs
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20100811123615.GA4879@redhat.com>
References: <20100804161046.GC5130@lenovo>
	 <20100804162026.GU3353@redhat.com> <20100804163930.GE5130@lenovo>
	 <20100804184806.GL26154@erda.amd.com> <20100804192634.GG5130@lenovo>
	 <20100806065203.GR26154@erda.amd.com> <20100806142131.GA1874@redhat.com>
	 <20100809194829.GB26154@erda.amd.com> <20100810204856.GA16571@redhat.com>
	 <1281496779.2744.1365.camel@yhuang-dev>  <20100811123615.GA4879@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 16:37:20 +0200
Message-ID: <1281969440.1926.1478.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-11 at 08:36 -0400, Don Zickus wrote:
> The only thing that might screw this up would be an SMI which takes longer
> than 1000 but that should be rare and would probably be related to the
> unknown NMI anyway. 

Long running SMIs aren't nearly as rare as you'd want them to be.
Hitting one in exactly the right spot will be, but given the numbers its
going to happen and make us scratch our heads..
