Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab1J1HMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 03:12:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34625 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab1J1HMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 03:12:44 -0400
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
From: Sasha Levin <levinsasha928@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
In-Reply-To: <20111027215243.GA31644@infradead.org>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	 <alpine.DEB.2.00.1110271318220.7639@chino.kir.corp.google.com20111027211157.GA1199@infradead.org>
	 <75efb251-7a5e-4aca-91e2-f85627090363@default>
	 <20111027215243.GA31644@infradead.org>
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 28 Oct 2011 09:12:36 +0200
Message-ID: <1319785956.3235.7.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 17:52 -0400, Christoph Hellwig wrote:
> On Thu, Oct 27, 2011 at 02:49:31PM -0700, Dan Magenheimer wrote:
> > If Linux truly subscribes to the "code rules" mantra, no core
> > VM developer has proposed anything -- even a design, let alone
> > working code -- that comes close to providing the functionality
> > and flexibility that frontswap (and cleancache) provides, and
> > frontswap provides it with a very VERY small impact on existing
> > kernel code AND has been posted and working for 2+ years.
> > (And during that 2+ years, excellent feedback has improved the
> > "kernel-ness" of the code, but NONE of the core frontswap
> > design/hooks have changed... because frontswap _just works_!)
> 
> It might work for whatever defintion of work, but you certainly couldn't
> convince anyone that matters that it's actually sexy and we'd actually
> need it.  Only actually working on Xen of course doesn't help.

Theres a working POC of it on KVM, mostly based on reusing in-kernel Xen
code.

I felt it would be difficult to try and merge any tmem KVM patches until
both frontswap and cleancache are in the kernel, thats why the
development is currently paused at the POC level.

-- 

Sasha.

