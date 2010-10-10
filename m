Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0JJHbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 03:31:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab0JJHbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 03:31:06 -0400
Date: Sun, 10 Oct 2010 09:30:41 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is
 swapped out.
Message-ID: <20101010073041.GK2397@redhat.com>
References: <1286207794-16120-1-git-send-email-gleb@redhat.com>
 <1286207794-16120-3-git-send-email-gleb@redhat.com>
 <4CAD97D0.70100@redhat.com>
 <20101007174716.GD2397@redhat.com>
 <4CB0B4BA.5010901@redhat.com>
 <4CB0B52E.90806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB0B52E.90806@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 08:32:14PM +0200, Avi Kivity wrote:
>  On 10/09/2010 08:30 PM, Avi Kivity wrote:
> >>So that "info cpu" will interfere with apf? Migration should work
> >>in regular way. apf state should not be migrated since it has no meaning
> >>on the destination. I'll make sure synthetic halt state will not
> >>interfere with migration.
> >
> >
> >If you deliver an apf, the guest expects a completion.
> >
> 
> btw, the token generation scheme resets as well.  Draining the queue
> fixes that as well.
> 
I don't see what's there to fix. Can you explain what problem you see in
the way current code works?

--
			Gleb.
