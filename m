Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1CaK2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:28:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40635 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1CaK2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:28:51 -0400
Date: Thu, 31 Mar 2011 12:28:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/9] x86 idle cruft removal - v2
Message-ID: <20110331102836.GA3723@elte.hu>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
 <1301551404-8263-1-git-send-email-lenb@kernel.org>
 <20110331104549.3065ab29@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331104549.3065ab29@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> We don't care if it doesn't work on a few machines (in fact we have
> a table to avoid that), we care that it *DOES* work on lots.
> 
> Removing it probably isn't a bad thing long term, but it's not appeared in
> the deprecated list and has not been there for several releases so it is
> not eligible for removal at this point.
> 
> People spent years getting Linux to support all this hardware and
> throwing bits out left right and centre to tidy up your current project
> is not the way it should be done.
> 
> So can we do this properly please. We have a process for good reason.
> 
> Deprecate it properly

Ok, agreed. Len, mind delaying this patch for a few releases?

> Add a printk/WARN_ON() indicating to the user it is deprecated but we
> will continue, and then give it a couple of releaes. Kerneloops.org will
> help answer whether that WARN_ON was hit.

Yeah, also add a -stable backport so that older kernel users have a chance to 
notice faster.

Thanks,

	Ingo
