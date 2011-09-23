Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab1IWIoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:44:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40209 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902Ab1IWIoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:44:14 -0400
Date: Fri, 23 Sep 2011 09:43:48 +0100
From: Will Deacon <will.deacon@arm.com>
To: mhban <mhban@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DavidHowells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH] ARM: futex: fix clobbering oldval
Message-ID: <20110923084348.GA5468@e102144-lin.cambridge.arm.com>
References: <1316660015.6872.1.camel@puffmine-laptop>
 <20110922172653.GH13572@e102144-lin.cambridge.arm.com>
 <1316737129.6872.17.camel@puffmine-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316737129.6872.17.camel@puffmine-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 01:18:49AM +0100, mhban wrote:
> On Thu, 2011-09-22 at 18:26 +0100, Will Deacon wrote:
> > 
> > It would have been nice to have been CC'd on this...
> 
> Will not miss next time. Thanks.

Thanks. You can use scripts/get_maintainer.pl to get a list of people to
email.

> > 
> > You shouldn't reference r5 directly here, but due to the way the futex code
> > is laid out, you can't add an extra output operand without converting the
> > code to use named arguments.
> > 
> > I'll post a patch to do that.
> > 
> > Will
> 
> I'm not familiar with gcc inline, thanks for pointing it out.

There's a good guide for ARM here:

http://www.ethernut.de/en/documents/arm-inline-asm.html

> BTW, my last name is Ban not Ben.

Oops, I'll update my reported-by to spell that correctly.

Cheers,

Will
