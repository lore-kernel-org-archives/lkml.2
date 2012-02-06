Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab2BFMIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 07:08:34 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:59518 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2BFMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 07:08:33 -0500
Date: Mon, 06 Feb 2012 07:08:30 -0500 (EST)
From: Ramon de C Valle <rcvalle@redhat.com>
Reply-To: Ramon de C Valle <rcvalle@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] New PT_GNU_COMPAT segment header extension
Message-ID: <b544312a-6cd1-475d-b719-c3d1cbe6fc3f@zmail15.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20120201141311.05b873ab.akpm@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.10.127]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

> <I have been poked>
> 
> I saw the patch but it's one of those ones which looks tricky/risky,
> and is in an area with which I'm not sufficiently familiar.  I used
> to
> ask Roland McGrath to help out with this sort of thing, but he
> dematerialised a while back.  Perhaps Linus can give it some thought?
> I'd suggest a resend: you've added useful info in later emails so
> there
> would be benefit to bringing it all together in one place.
> 
> A couple of minor things:
> 
> - The patch will need a Signed-off-by:, as described in
>   Documentation/SubmittingPatches.

Sure. I'm going to resend the patches properly formatted with all
information together.

> 
> - The term "compat" has a well-understood meaning in the kernel: it
>   refers to the support of 32-bit executables under 64-bit kernels.
>   Adding an unrelated PT_GNU_COMPAT muddies this.  Can you think up a
>   different term?

I previously thought about using PT_GNU_LEGACY. Sounds reasonable?

> 
> 
> 

-- 
Ramon de C Valle / Red Hat Security Response Team
