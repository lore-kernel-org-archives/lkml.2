Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab0GHNgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:36:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60076 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838Ab0GHNgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:36:20 -0400
Date: Thu, 8 Jul 2010 16:35:42 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: Re: [PATCH v4 11/12] Let host know whether the guest can handle
 async PF in non-userspace context.
Message-ID: <20100708133542.GX4689@redhat.com>
References: <1278433500-29884-1-git-send-email-gleb@redhat.com>
 <1278433500-29884-12-git-send-email-gleb@redhat.com>
 <4C3553E2.7020607@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3553E2.7020607@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 12:28:18AM -0400, Rik van Riel wrote:
> On 07/06/2010 12:24 PM, Gleb Natapov wrote:
> >If guest can detect that it runs in non-preemptable context it can
> >handle async PFs at any time, so let host know that it can send async
> >PF even if guest cpu is not in userspace.
> 
> The code looks correct.  One question though - is there a
> reason to implement the userspace-only async PF path at
> all, since the handling of async PF in non-userspace context
> is introduced simultaneously?
> 
Guest userspace-only async PF handling is added in patch 4 and
non-userspace is added in patch 10. It is done for easy reviewing.
If I implement everything in one patch it will be harder to see why
things are done the way they are IMHO.

--
			Gleb.
