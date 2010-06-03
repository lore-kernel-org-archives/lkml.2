Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab0FCTfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:35:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40961 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab0FCTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:35:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6002"; a="43348249"
Subject: Re: ARM defconfig files
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arm-msm@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
References: <20100603074548.GA12104@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006030725420.8175@i5.linux-foundation.org>
	 <20100603181010.GA25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031116360.8175@i5.linux-foundation.org>
	 <20100603185333.GD25779@flint.arm.linux.org.uk>
	 <alpine.LFD.2.00.1006031153420.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 12:35:42 -0700
Message-ID: <1275593742.23384.48.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-03 at 11:56 -0700, Linus Torvalds wrote:
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
> 
> In other words, you _can_ encode the information that is in the 
> xyz_defconfig files by doing it in Kconfig.xyz files instead. But you do 
> it in a human-readable manner. And the hierarchical thing is absolutely 
> required for that - otherwise you'd end up with just another form of the 
> current xyz_defconfig.
> 
> See?
> 
> In other words, you should be able to basically use "make allnoconfig" 
> together with a Kconfig.xyz file input to select _exactly_ the pieces you 
> need, and nothing else.

If you did this for drivers, what about disabling a driver? If we used
"select" wouldn't that force all the drivers on without allowing it to
be unselected?

Daniel

