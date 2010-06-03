Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0FCTVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:21:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50643 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0FCTU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:20:59 -0400
Date: Thu, 3 Jun 2010 20:20:31 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100603192031.GE25779@flint.arm.linux.org.uk>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org> <20100603185333.GD25779@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:56:53AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 3 Jun 2010, Russell King wrote:
> > 
> > No amount of reorganising the Kconfig files into a heirarchial manner
> > (which they already are) helps.  Not one bit.  Because they already are.
> > That's not where the problem is.
> 
> I don't think you read the whole thread.
> 
> Earlier on, I explained exactly what I wanted: just add some "select" 
> statements to pickt he things you need per the particular target 
> configuration. You seem to have missed that part.

Isn't that _also_ what I suggested with one modification - which
was based on your suggestion with a _bit_ _more_ _thought_?  Oddly
that suggestion which you appear to have completely ignored - but
clearly you did get the mail because you quoted a few lines from it
in one of your subsequent replies - was based on your very idea.
The one which you said "what was the point of your mail".

Maybe the point is to discuss issues.  You know, it's exceedingly
difficult to discuss things if the other side doesn't read messages
they're sent.  Ergo, I don't think there's any point discussing this
any further; you've crystal clearly already stopped listening.

Maybe you should go back to that one which you gave such a flippant
reply to and re-read it, and actually productively comment on my
additional suggestion to yours?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
