Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab0FCSWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 14:22:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754405Ab0FCSWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 14:22:46 -0400
Date: Thu, 3 Jun 2010 11:18:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King <rmk@arm.linux.org.uk>
cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
Subject: Re: ARM defconfig files
In-Reply-To: <20100603181010.GA25779@flint.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk> <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org> <20100603181010.GA25779@flint.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 3 Jun 2010, Russell King wrote:
> 
> Umm.  I don't think you've actually looked at the Kconfig files if you're
> writing this, because that's precisely what we already do.

.. but if you do this _right_, then the defconfig files would be 
unnecessary.

That's my point. If you are right, then I can remove the defconfig files 
entirely. Are you ready for that?

And if you aren't ready for that, then what was the point of your email?

		Linus
