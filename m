Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab0FDAgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:36:19 -0400
Received: from ozlabs.org ([203.10.76.45]:54914 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab0FDAgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:36:18 -0400
Date: Fri, 4 Jun 2010 10:36:07 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Daniel Walker <dwalker@codeaurora.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
Message-ID: <20100604003607.GC24687@brick.ozlabs.ibm.com>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
 <20100603181010.GA25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
 <20100603185333.GD25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
 <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
 <20100603194559.GF25779@flint.arm.linux.org.uk>
 <alpine.LFD.2.00.1006031305310.8175@i5.linux-foundation.org>
 <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:31:07PM -0700, Linus Torvalds wrote:

> Now, the above is a _trivial_ one. And it's actually broken, because I 
> should not have forced CONFIG_USB (it depends on CONFIG_USB_SUPPORT). 

Seems to me that the brokenness of select is the main technical issue
stopping us getting rid of the defconfigs.  If there was a way to tell
the Kconfig machinery "I want CONFIG_USB on, you figure out what has
to be enabled for that to make sense" then it would all work.  But
that's a hard problem (and may possibly have multiple solutions).

Paul.
