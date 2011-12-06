Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1LFRvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:51:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50636 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751330Ab1LFRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:51:03 -0500
Date: Tue, 6 Dec 2011 17:52:30 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Bowler <nbowler@elliptictech.com>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, ben@decadent.org.uk,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] lockdep, bug: Exclude
 TAINT_FIRMWARE_WORKAROUND from disabling lockdep
Message-ID: <20111206175230.2c5b2ea0@lxorguk.ukuu.org.uk>
In-Reply-To: <20111206174320.GA25031@elte.hu>
References: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
	<20111206151345.GA22353@elliptictech.com>
	<20111206154206.441e85c6@lxorguk.ukuu.org.uk>
	<20111206174320.GA25031@elte.hu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My primary worry is to not have lockdep active when there's 
> binary modules in a system - can TAINT_OOT_MODULE be set but 
> TAINT_PROPRIETARY_MODULE not set for non-GPL modules?

Yes. I imagine anyone wanting to use lockdep with binary modules
would just lie anyway.

> If not, and if TAINT_OOT_MODULE set and TAINT_PROPRIETARY_MODULE 
> cleared guarantees the GPL-ness of the module then i have no 
> problem with keeping lockdep active in that case.

Insofar as nobody is making their code line about licenses.

Alan
