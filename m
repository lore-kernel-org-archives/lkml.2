Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab1KJVNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 16:13:39 -0500
Received: from gate.crashing.org ([63.228.1.57]:46106 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab1KJVNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 16:13:37 -0500
Message-ID: <1320959579.21206.24.camel@pasglop>
Subject: Re: mm: convert vma->vm_flags to 64bit
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: nai.xia@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, hughd@google.com, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, lethal@linux-sh.org,
        linux@arm.linux.org.uk
Date: Fri, 11 Nov 2011 08:12:59 +1100
In-Reply-To: <4EBC085D.3060107@jp.fujitsu.com>
References: <20110412151116.B50D.A69D9226@jp.fujitsu.com>
	 <CAPQyPG7RrpV8DBV_Qcgr2at_r25_ngjy_84J2FqzRPGfA3PGDA@mail.gmail.com>
	 <4EBC085D.3060107@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 12:22 -0500, KOSAKI Motohiro wrote:
> On 11/9/2011 11:09 PM, Nai Xia wrote:
> > Hi all,
> > 
> > Did this patch get merged at last, or on this way being merged, or
> > just dropped ?
> 
> Dropped.
> Linus said he dislike 64bit enhancement.

Do you have a pointer ? (And a rationale)

I still want to put some arch flags in there at some point...

Cheers,
Ben.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


