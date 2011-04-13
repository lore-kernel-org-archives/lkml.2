Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab1DMHBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 03:01:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:42190 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab1DMHBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 03:01:31 -0400
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <20110413064432.GA4098@p183>
References: <BANLkTinLdWB+ON=TY=KHyzsrC8gC5bXg7Q@mail.gmail.com>
	 <1302646024.28876.52.camel@pasglop>
	 <20110413091301.41E1.A69D9226@jp.fujitsu.com>  <20110413064432.GA4098@p183>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 17:00:49 +1000
Message-ID: <1302678049.28876.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 09:44 +0300, Alexey Dobriyan wrote:
> > Yes, I take Hugh's version because vm_flags_t is ugly to me. And
> arch 
> > dependent variable size is problematic.
> 
> Who said it should have arch-dependent size? 

Right, it shouldn't. My original patch did that to avoid thinking about
archs that manipulated it from asm such as ARM but that wasn't the right
thing to do. But that doesn't invalidate having a type.

Cheers,
Ben.


