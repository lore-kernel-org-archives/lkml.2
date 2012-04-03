Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2DCO0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 10:26:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48361 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2DCO0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 10:26:42 -0400
Date: Tue, 3 Apr 2012 10:21:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ben Guthro <ben@guthro.net>
Cc: Konrad Rzeszutek <konrad@darnok.org>, Greg Kroah-Hartman <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.2.14 pvops crash in xen_irq_init
Message-ID: <20120403142106.GA27054@phenom.dumpdata.com>
References: <CAOvdn6WiaOxMh=b0LX6GEK4p8RiZQYamGb-qPyThfOf=E_wj6g@mail.gmail.com>
 <20120403132237.GD12464@phenom.dumpdata.com>
 <CAOvdn6VZ1wCOhv6HXK84GiAd3EhTGght_5=_AgDhPZGWp0wB5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOvdn6VZ1wCOhv6HXK84GiAd3EhTGght_5=_AgDhPZGWp0wB5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F7B0869.00A2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 10:17:55AM -0400, Ben Guthro wrote:
> Konrad - it looks like that solved my issue - thanks for the prompt reply.
> 
> I think I found the thread talking about this issue here:
> https://lkml.org/lkml/2012/3/20/349
> 
> ...though I'm having trouble sifting through the replies to find a resolution.
> 
> What, of the following would you recommend for a longer term solution?
> a.) For Greg to revert this in the stable tree

a).

> b.) Apply some patch that resolves this issue in -stable (if a
> solution was found)
> c.) For me (and anyone else using 3.2.y for pvops) to revert this
> changeset when picking up future changes?
