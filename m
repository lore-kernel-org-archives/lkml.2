Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab1JPA6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 20:58:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46064 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab1JPA6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 20:58:16 -0400
Subject: Re: Please include const-sections into linux-next
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1110151752060.5728@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org>
	 <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
	 <alpine.DEB.2.00.1110151543220.25063@chino.kir.corp.google.com>
	 <1318722567.7271.56.camel@dabdike.int.hansenpartnership.com>
	 <alpine.DEB.2.00.1110151752060.5728@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Oct 2011 19:58:14 -0500
Message-ID: <1318726694.7271.61.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-10-15 at 17:53 -0700, David Rientjes wrote:
> On Sat, 15 Oct 2011, James Bottomley wrote:
> 
> > I think it's probably a compiler bug.  gcc isn't as adept with section
> > annotations as people think it is.  This tends to manifest in the
> > non-x86 toolchains because we tend to be using earlier versions.
> > 
> 
> It compiles fine with my cross-compiler using gcc-4.5.1.

So it's a native toolchain bug in gcc ... the point still stands:
there'll be tons of these throughout non x86 tool chains.  You can't
break every arch under the sun just for a dubious mark stuff const.

James


