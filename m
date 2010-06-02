Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab0FBV4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 17:56:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52613 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758647Ab0FBV4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 17:56:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6001"; a="43250911"
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
From: Daniel Walker <dwalker@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1006021430100.8175@i5.linux-foundation.org>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>
	 <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
	 <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
	 <alpine.LFD.2.00.1006021430100.8175@i5.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 14:56:17 -0700
Message-ID: <1275515777.27006.48.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 14:39 -0700, Linus Torvalds wrote:
> 
> On Wed, 2 Jun 2010, Linus Torvalds wrote:
> > 
> > I got a bit frustrated with ten different ARM pulls per day at one point.
> 
> In other words - when I do a "git pull", I really want to feel like there 
> is some point to it. When I get ten different ARM maintainers asking me to 
> pull stuff that just looks like noise, I'm just not getting those warm and 
> fuzzies about them. 
> 
> I'm also getting the feeling that now that different arch sub-architecture 
> maintainers all try to get their stuff in through me, things have actually 
> gotten worse - there's even less feeling of "somebody is actually trying 
> to keep track of all this stuff".
> 
> I understand why rmk wasn't happy. I'm also not really happy. 

Should all us ARM sub-architecture maintainers get together and make a
jumbo pull request with everything merged together?

Like someone, not you or RMK, would take all the sub-architecture
requests and put them into a single pull request w/ lots of details as
to what it all is ..

I know that doesn't solve what you said in the original email, how we
develop. One thing to remember is that we have tons of ARM device to
manage, and lots of chip manufactures .. So ARM is pretty diverse. I'm
not saying we're all perfect however.

Daniel


