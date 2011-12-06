Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab1LFRyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:54:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50667 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab1LFRyU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:54:20 -0500
Date: Tue, 6 Dec 2011 17:55:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ben Hutchings <ben@decadent.org.uk>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, rtmutex, bug: Show taint flags on
 error
Message-ID: <20111206175558.3215907c@lxorguk.ukuu.org.uk>
In-Reply-To: <1323193731.32012.81.camel@twins>
References: <1319773015.6759.30.camel@deadeye>
	<tip-fbdc4b9a6c29befbcca65e5366e5aaf2abb7a013@git.kernel.org>
	<1323185640.7454.269.camel@deadeye>
	<1323193731.32012.81.camel@twins>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Dec 2011 18:48:51 +0100
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2011-12-06 at 15:34 +0000, Ben Hutchings wrote:
> > If you disagree with a patch, do not silently drop parts of it.  I
> > demand that you remove my 'Signed-off-by' as this is not the change I
> > submitted. 
> 
> The easy solution is that I never take patches from you again, ever.
> Consider that done. I'll let Ingo see if he can remove your SOB.

In which case you are presumably ceasing to be a maintainer for that
code ? Your statement above appears to be inconsistent with the rôle of a
maintainer.

Alan
