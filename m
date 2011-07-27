Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1G0QZA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:25:00 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50598 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743Ab1G0QYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:24:49 -0400
X-Sasl-enc: 0o2ZPo3eGGVm3W5utNaNz52CX4yQKcUQ5qHerZlI43vb 1311783888
Date: Wed, 27 Jul 2011 09:15:42 -0700
From: Greg KH <greg@kroah.com>
To: Will Newton <will.newton@gmail.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [stable] [PATCH] bitops: Use volatile in generic atomic bitops.
Message-ID: <20110727161542.GA20238@kroah.com>
References: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 01:21:19PM +0100, Will Newton wrote:
> The generic atomic bitops currently explicitly cast away the
> volatile from the pointer passed to them. This will allow the
> access to the bitfield to happen outside of the critical section
> thus making the bitops no longer interrupt-safe. Remove this cast
> and add a volatile keyword to make sure all accesses to the
> bitfield happen inside the critical section.
> 
> Signed-off-by: Will Newton <will.newton@imgtec.com>
> ---
>  include/asm-generic/bitops/atomic.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
