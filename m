Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab1LFSUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:20:20 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50781 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752826Ab1LFSUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:20:18 -0500
Date: Tue, 6 Dec 2011 18:21:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Ben Hutchings <ben@decadent.org.uk>,
        mingo@redhat.com, hpa@zytor.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206182155.6b4dedc3@lxorguk.ukuu.org.uk>
In-Reply-To: <20111206181422.GA11881@elliptictech.com>
References: <1319773015.6759.30.camel@deadeye>
	<tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
	<1323185640.7454.269.camel@deadeye>
	<20111206175443.GB25031@elte.hu>
	<20111206181422.GA11881@elliptictech.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> FYI, there's no "I will only sign off on a patch doing two 
> things if it's applied in full" kind of condition in the SOB 
> definition, allowing that would break the GPL: people have the 
> right to take your modifications to the GPL-ed kernel and modify 
> it further.

That gets into moral rights, and at least in the EU representing someone
as the author of something they are not isn't a good idea even before you
get to any contractual or licensing questions. I don't believe the EU is
unusual in this point either.

Alan
