Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab1J0Vwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 17:52:51 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52343
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab1J0Vwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 17:52:49 -0400
Date: Thu, 27 Oct 2011 17:52:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
Message-ID: <20111027215243.GA31644@infradead.org>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <alpine.DEB.2.00.1110271318220.7639@chino.kir.corp.google.com20111027211157.GA1199@infradead.org>
 <75efb251-7a5e-4aca-91e2-f85627090363@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75efb251-7a5e-4aca-91e2-f85627090363@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 02:49:31PM -0700, Dan Magenheimer wrote:
> If Linux truly subscribes to the "code rules" mantra, no core
> VM developer has proposed anything -- even a design, let alone
> working code -- that comes close to providing the functionality
> and flexibility that frontswap (and cleancache) provides, and
> frontswap provides it with a very VERY small impact on existing
> kernel code AND has been posted and working for 2+ years.
> (And during that 2+ years, excellent feedback has improved the
> "kernel-ness" of the code, but NONE of the core frontswap
> design/hooks have changed... because frontswap _just works_!)

It might work for whatever defintion of work, but you certainly couldn't
convince anyone that matters that it's actually sexy and we'd actually
need it.  Only actually working on Xen of course doesn't help.

In the end it's a bunch of really ugly hooks over core code, without
a clear defintion of how they work or a killer use case.

