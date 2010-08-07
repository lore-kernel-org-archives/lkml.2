Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617Ab0HGLhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 07:37:22 -0400
Received: from ozlabs.org ([203.10.76.45]:42696 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab0HGLhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 07:37:20 -0400
Date: Sat, 7 Aug 2010 21:37:09 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] timekeeping updates for 2.6.36
Message-ID: <20100807113709.GA6242@brick.ozlabs.ibm.com>
References: <alpine.LFD.2.00.1008060016300.3225@localhost.localdomain>
 <AANLkTi=UXQ2EfSNNAudHeEGybaNJpzz6ku8RcfRzOpct@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=UXQ2EfSNNAudHeEGybaNJpzz6ku8RcfRzOpct@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 01:25:22PM -0700, Linus Torvalds wrote:

> Well, it just resulted in another merge conflict, but I resolved it
> the same way you had resolved your cherry-picks. However, I wanted to
> let people know, so that the powerpc guys can re-verify that whole
> vsyscall timer change.
> 
> So Paul, Ben, please check out that I didn't screw something up in there.

Looks fine, thanks.

Paul.
