Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1HBKIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:08:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50221 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586Ab1HBKIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:08:13 -0400
Date: Tue, 2 Aug 2011 11:11:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: Revert needed: udev spewing warnons on common systems in 3.0
Message-ID: <20110802111117.10a73b89@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com>
References: <20110802005206.GA3832@tassilo.jf.intel.com>
	<20110801183207.cea89a96.akpm@linux-foundation.org>
	<CA+55aFw=wX1CormdOAnsoK2ruDLp9SaEVh1EcTj8wvt+Kq2gAg@mail.gmail.com>
	<alpine.DEB.2.00.1108011916480.15596@chino.kir.corp.google.com>
	<20110802101614.009cdf42@lxorguk.ukuu.org.uk>
	<alpine.DEB.2.00.1108020249560.18935@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> That's obviously wrong since all of the applications that I've cited 
> that have been fixed to date have been the result of users actually 
> noticing the printk_once() and emailing me directly to pass it along to 
> the appropriate parties.  I've also found other cases where bugzilla 
> entries were created based on that single line warning by users, who in 
> turn get distros and maintainers to convert to the new interface.

And what did the users do - they complained to the distribution.

> It's quite effective, but there are still some applications that have yet 
> to be reported, hence the reason for anybody actually hitting this new 
> WARN_ONCE().

Perhaps the right way to do it would be to file the bugzillas in the key
distros instead

Actually this raises a more interesting question - would it make sense to
have a moderated notification list for poking all the distributions about
things like old API expiry >

