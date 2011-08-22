Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab1HVBqe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:46:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34907 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab1HVBqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:46:33 -0400
Date: Mon, 22 Aug 2011 03:46:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a personality to report 2.6.x version numbers
Message-ID: <20110822014628.GO25996@one.firstfloor.org>
References: <1313795710-30827-1-git-send-email-andi@firstfloor.org> <CACqU3MWgZG_jGs+26X05nXUpbihASU7JXaBct=ZBnR7SEWLc+w@mail.gmail.com> <20110821231354.GL25996@one.firstfloor.org> <CACqU3MUAuMMC0c1Aesb3-oSzRXw4ddRYtjKDYovXewbCFL6dFg@mail.gmail.com> <20110822001121.GN25996@one.firstfloor.org> <CACqU3MWuQKVVwtP8hcUd1a3kcG3+NOyFz+meJM1XW6vo9H6HFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACqU3MWuQKVVwtP8hcUd1a3kcG3+NOyFz+meJM1XW6vo9H6HFQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 09:04:04PM -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Sun, Aug 21, 2011 at 8:11 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >> It does not work if / on a ROM, unless you start using trampoline
> >> partition, but this is starting to become really convoluted...
> >
> > On a ROM you never change the kernel.
> >
> For this particular board, the kernel is on a small read-write NOR
> flash, and the userland on write-protected NAND chip.

You can use a initrd

And hopefully it's not connected to any network, because you can't
fix any security holes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
