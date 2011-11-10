Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668Ab1KJNww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 08:52:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:48696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab1KJNwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 08:52:50 -0500
Message-ID: <1320933165.17392.24.camel@i7.infradead.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 10 Nov 2011 13:52:45 +0000
In-Reply-To: <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
References: <20111026202235.GA20928@havoc.gtf.org>
	 <1319969101.5215.20.camel@dabdike>
	 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
	 <1320049150.8283.19.camel@dabdike>
	 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
	 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
	 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
	 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
	 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 (3.2.1-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-01 at 14:21 -0700, Linus Torvalds wrote:
> I hate how anonymous our branches are. Sure, we can use good names for
> them, but it was a mistake to think we should describe the repository
> (for gitweb), rather than the branch.
> 
> Ok, "hate" is a strong word. I don't "hate" it. I don't even think
> it's a major design issue. But I do think that it would have been
> nicer if we had had some branch description model. 

I actually quite like it. I take it as a hint: if the contents of a
branch are *so* wildly different from the main repository that they need
a different description, perhaps I should be using a separate repository
instead of just a branch.

-- 
dwmw2

