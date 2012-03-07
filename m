Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292Ab2CGBih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:38:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:52401 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964983Ab2CGBih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:38:37 -0500
Message-ID: <1331084302.11248.338.camel@twins>
Subject: Re: [PATCH bisected regression] sched: rebuild sched domains at
 suspend/resume
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Wed, 07 Mar 2012 02:38:22 +0100
In-Reply-To: <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com>
References: <20120306204357.13169.90791.stgit@zurg>
	 <1331067743.11248.333.camel@twins>
	 <CA+55aFxPiW=T8iNy=Fb_fuO2DYV9+sQL-mr8=Uc7cWymTyVt6A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 16:54 -0800, Linus Torvalds wrote:
> I do agree that reverting is probably safer at this point, but can we
> get agreement on this? 

I agree with reverting, shoot it in the head :-) Do you want a git
thingy?
