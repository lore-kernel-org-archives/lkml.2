Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1ALWXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:23:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44855 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab1ALWXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:23:49 -0500
Date: Wed, 12 Jan 2011 22:23:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Bug: loops_per_jiffy based udelay() mostly shorter than
	requested
Message-ID: <20110112222337.GK11039@n2100.arm.linux.org.uk>
References: <20110109170829.GA14252@flint.arm.linux.org.uk> <AANLkTik5BmZAOFdYVGAjuoHftQ3qh1oTCEr5MpkCiDVz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik5BmZAOFdYVGAjuoHftQ3qh1oTCEr5MpkCiDVz@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 01:19:49PM -0800, Linus Torvalds wrote:
> On Sun, Jan 9, 2011 at 9:08 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> >
> > Any suggestions or thoughts, or should we not care too much if udelay()
> > produces slightly shorter than desired delays?  Or am I doing something
> > horribly wrong in the ARM code?
> 
> Judging by the numbers you quote, I would definitely put this in the
> "don't care too much".

Thanks - that's my thoughts too.  I think I'm still going to push out
the rounding patch for the sake of correctness even though it's down
in the noise.
