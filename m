Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab1GAUVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 16:21:52 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58196 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1GAUVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 16:21:51 -0400
Date: Fri, 1 Jul 2011 22:21:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: ling.ma@intel.com, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2 ] [x86] Modify comments and clean up code.
Message-ID: <20110701202139.GB20865@elte.hu>
References: <1309300570-789-1-git-send-email-ling.ma@intel.com>
 <m2y60hlpu5.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2y60hlpu5.fsf@firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> ling.ma@intel.com writes:
> 
> > From: Ma Ling <ling.ma@intel.com>
> >
> > Modern CPU use fast-string instruction to accelerate copy performance,
> > by combining data into 128bit, so we modify comments and code style.
> 
> The description has nothing to do with the patch.
> 
> As far as I can tell the patch just renames one symbol
> and changes all white space. Not fully sure what the point of it 
> is. 
> 
> But normally white space change patches are not supposed to have 
> any other changes because the other changes embedded in them are 
> impossible to review.

Non-functional cleanups can go into the same patch as whitespace 
cleanups, as long as the generated object code does not change.

Thanks,

	Ingo
