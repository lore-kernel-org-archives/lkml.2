Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2HFQW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:22:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:27628 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932242Ab2HFQWz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:22:55 -0400
MIME-Version: 1.0
Message-ID: <be1daa96-d246-46de-a178-b14b3a862eca@default>
Date: Mon, 6 Aug 2012 09:21:22 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <b95aec06-5a10-4f83-bdfd-e7f6adabd9df@default>
 <20120727205932.GA12650@localhost.localdomain>
 <d4656ba5-d6d1-4c36-a6c8-f6ecd193b31d@default>
 <5016DE4E.5050300@linux.vnet.ibm.com>
 <f47a6d86-785f-498c-8ee5-0d2df1b2616c@default>
 <20120731155843.GP4789@phenom.dumpdata.com> <20120731161916.GA4941@kroah.com>
 <20120731175142.GE29533@phenom.dumpdata.com> <20120806003816.GA11375@bbox>
 <041cb4ce-48ae-4600-9f11-d722bc03b9cc@default>
 <CAOJsxLHDcgxxu146QWXw0ZhMHMhFOquEFXhF55HK2mCjHzk7hw@mail.gmail.com>
In-Reply-To: <CAOJsxLHDcgxxu146QWXw0ZhMHMhFOquEFXhF55HK2mCjHzk7hw@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pekka Enberg [mailto:penberg@kernel.org]
> Subject: Re: [PATCH 0/4] promote zcache from staging
> 
> On Mon, Aug 6, 2012 at 6:24 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> > IMHO, the fastest way to get the best zcache into the kernel and
> > to distros and users is to throw away the "demo" version, move forward
> > to a new solid well-designed zcache code base, and work together to
> > build on it.  There's still a lot to do so I hope we can work together.
> 
> I'm not convinced it's the _fastest way_.

<grin> I guess I meant "optimal", combining "fast" and "best".

> You're effectively
> invalidating all the work done under drivers/staging so you might end up
> in review limbo with your shiny new code...

Fixing the fundamental design flaws will sooner or later invalidate
most (or all) of the previous testing/work anyway, won't it?  Since
any kernel built with staging is "tainted" already, I feel like now
is a better time to make a major design transition.

I suppose:

 (E) replace "demo" zcache with new code base and keep it
     in staging for another cycle

is another alternative, but I think gregkh has said no to that.

Dan
