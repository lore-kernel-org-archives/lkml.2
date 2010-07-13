Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab0GMUp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:45:26 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:46415 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab0GMUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:45:24 -0400
Message-ID: <4C3CD060.50904@davidnewall.com>
Date: Wed, 14 Jul 2010 06:15:20 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Marcin Letyns <mletyns@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: stable? quality assurance?
References: <201007110918.42120.Martin@lichtvoll.de>	<20100711131640.GA3503@thunk.org>	<4C3ABA35.7020507@davidnewall.com> <AANLkTilGjfx9sb66qVfZn1SeFPURHUrrdE7JCrild8VX@mail.gmail.com> <4C3B3B39.2000809@davidnewall.com> <4735EF77-6C7D-46D6-8C2B-C910A2D662D2@mit.edu>
In-Reply-To: <4735EF77-6C7D-46D6-8C2B-C910A2D662D2@mit.edu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> What this means is yes that stable basically means, "stable
> for the core kernel developers".   You can say that this isn't
> correct, and maybe even dishonest, but if we wait until 2.6.34.N
> before we call a release "stable", and this discourages users
> from testing 2.6.34.M for M<N, it just delays when bugs will
> be found and fixed.
>   

Calling it stable instils and reinforces a Pavlovian response in typical 
users, that recent Linux kernels are dangerous and unreliable; one year 
old was suggested as a safe benchmark. Typical users being 99% of the 
population, testing hardly begins until a kernel is "sufficiently old." 
This Pavlovian response is what really delays finding and fixing bugs. 
Being up-front and saying which kernels are likely to fail would help 
many users calculate the risk and improve their willingness to try newer 
kernels. "Sufficiently old" might well come down to six months, maybe four.

That is to say, instead of taking a year to pass gamma-testing, new 
kernels could be passed in six months or less. That would be a big 
improvement in stability and quality assurance however you dice it.


> But demanding that kernel.org become "more stable" when it
> is supported by purely volunteers is simply not reasonable.

Let's not be hysterical; nobody made any demands. Semantics aside, the 
suggestion is reasonable because it affects developers' workloads not 
one whit. The only change is the label that Linus applies to new releases.
