Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2HFQkO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:40:14 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33604 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684Ab2HFQkM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:40:12 -0400
MIME-Version: 1.0
Message-ID: <d4f82064-71ba-4712-b831-6499180589b9@default>
Date: Mon, 6 Aug 2012 09:38:52 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, devel@driverdev.osuosl.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: RE: [PATCH 0/4] promote zcache from staging
References: <d4656ba5-d6d1-4c36-a6c8-f6ecd193b31d@default>
 <5016DE4E.5050300@linux.vnet.ibm.com>
 <f47a6d86-785f-498c-8ee5-0d2df1b2616c@default>
 <20120731155843.GP4789@phenom.dumpdata.com> <20120731161916.GA4941@kroah.com>
 <20120731175142.GE29533@phenom.dumpdata.com> <20120806003816.GA11375@bbox>
 <041cb4ce-48ae-4600-9f11-d722bc03b9cc@default>
 <CAOJsxLHDcgxxu146QWXw0ZhMHMhFOquEFXhF55HK2mCjHzk7hw@mail.gmail.com>
 <be1daa96-d246-46de-a178-b14b3a862eca@default>
 <20120806162948.GA27634@kroah.com>
In-Reply-To: <20120806162948.GA27634@kroah.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Subject: Re: [PATCH 0/4] promote zcache from staging
> 
> On Mon, Aug 06, 2012 at 09:21:22AM -0700, Dan Magenheimer wrote:
> > I suppose:
> >
> >  (E) replace "demo" zcache with new code base and keep it
> >      in staging for another cycle
> >
> > is another alternative, but I think gregkh has said no to that.
> 
> No I have not.  If you all feel that the existing code needs to be
> dropped and replaced with a totally new version, that's fine with me.
> It's forward progress, which is all that I ask for.
> 
> Hope this helps,
> greg k-h

Hi Greg --

Cool!  I guess I mistakenly assumed that your "no new features"
requirement also implied "no fixes of fundamental design flaws". :-)

Having option (E) should make it easier to decide the best
technical solution, separate from the promotion timing and "where
does it land" question.

We'll get back to you soon...

Thanks!
Dan
