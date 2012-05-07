Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2EGPwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 11:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756807Ab2EGPwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 11:52:15 -0400
Date: Mon, 7 May 2012 11:52:09 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] x86, reboot: revert stop_other_cpus to using IRQ
 with NMI fallback
Message-ID: <20120507155209.GX32472@redhat.com>
References: <1333052651-8200-1-git-send-email-dzickus@redhat.com>
 <20120507131021.GE23858@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120507131021.GE23858@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 03:10:21PM +0200, Ingo Molnar wrote:
> 
> * Don Zickus <dzickus@redhat.com> wrote:
> 
> > The end result of this more 
> > complicated-looking-diff-than-it-really-is, is a patch that 
> > mostly reverts
> > 
> > 3603a25 x86, reboot: Use NMI instead of REBOOT_VECTOR to stop cpus
> > 
> > and instead just sticks another if-case after the REBOOT_IRQ 
> > and checks to see if online_cpus are still > 1, and if so, 
> > clobber the rest of the cpus with an NMI.
> 
> Ok, would be nice to shape this as a 'dumb' revert as-is, and do 
> the simple change in a separate patch, or so. That makes it 
> easier to review (and easier to debug, should it break).

Heh.  I thought about that.  I can do that and resend.

Cheers,
Don
