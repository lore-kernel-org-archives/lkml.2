Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab1J0Vtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 17:49:46 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:57347 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab1J0Vtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 17:49:45 -0400
MIME-Version: 1.0
Message-ID: <75efb251-7a5e-4aca-91e2-f85627090363@default>
Date: Thu, 27 Oct 2011 14:49:31 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <alpine.DEB.2.00.1110271318220.7639@chino.kir.corp.google.com
 20111027211157.GA1199@infradead.org>
In-Reply-To: <20111027211157.GA1199@infradead.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4EA9D1EC.0055,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, October 27, 2011 3:12 PM
> To: David Rientjes
> Cc: Dan Magenheimer; Linus Torvalds; linux-mm@kvack.org; LKML; Andrew Morton; Konrad Wilk; Jeremy
> Fitzhardinge; Seth Jennings; ngupta@vflare.org; levinsasha928@gmail.com; Chris Mason;
> JBeulich@novell.com; Dave Hansen; Jonathan Corbet; Neo Jia
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
> 
> On Thu, Oct 27, 2011 at 01:18:40PM -0700, David Rientjes wrote:
> > Isn't this something that should go through the -mm tree?
> 
> It should have.  It should also have ACKs from the core VM developers,
> and at least the few I talked to about it really didn't seem to like it.

Yes, it would have been nice to have it go through the -mm tree.
But, *sigh*, I guess it will be up to Linus again to decide if
"didn't seem to like it" is sufficient to block functionality
that has found use by a number of in-kernel users and by
real shipping products... and continues to grow in usefulness.

If Linux truly subscribes to the "code rules" mantra, no core
VM developer has proposed anything -- even a design, let alone
working code -- that comes close to providing the functionality
and flexibility that frontswap (and cleancache) provides, and
frontswap provides it with a very VERY small impact on existing
kernel code AND has been posted and working for 2+ years.
(And during that 2+ years, excellent feedback has improved the
"kernel-ness" of the code, but NONE of the core frontswap
design/hooks have changed... because frontswap _just works_!)

Perhaps other frontswap users would be so kind as to reply
on this thread with their opinions...

Dan

