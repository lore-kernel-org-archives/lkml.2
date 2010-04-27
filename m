Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab0D0Q6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:58:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:57186 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab0D0Q6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:58:14 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+QtWgtj4M2H1HhB9G17i6+
Date: Tue, 27 Apr 2010 09:58:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] omap fixes for v2.6.34-rc5
Message-ID: <20100427165813.GC7225@atomide.com>
References: <20100426190005.GJ7225@atomide.com>
 <alpine.LFD.2.00.1004270831430.3739@i5.linux-foundation.org>
 <20100427161217.GB7225@atomide.com>
 <alpine.LFD.2.00.1004270934220.3739@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004270934220.3739@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds <torvalds@linux-foundation.org> [100427 09:31]:
> 
> 
> On Tue, 27 Apr 2010, Tony Lindgren wrote:
> > 
> > OK point taken. I should have dealt with this earlier. Will only queue
> > regressions after -rc3 or so.
> 
> Note that the "only regressions" is certainly not a hard rule. Anything 
> that would be valid for -stable is obviously always valid: security 
> issues, major oopses etc etc.

Sure.
 
> But the "only regressions" should kind of be the guiding line, and the 
> others are more like "this is so serious that it should go in regardless 
> of anything else".

OK. I guess was using criteria like "this is needed to boot this and that
board in a usable way" and "let's get all the fixes in" criteria, but that
should have been done way earlier.

Regards,

Tony
