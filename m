Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1AVV7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 16:59:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45704 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892Ab1AVV7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 16:59:49 -0500
Date: Sat, 22 Jan 2011 21:57:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Brian Swetland <swetland@google.com>, Pekka Enberg <penberg@kernel.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dima Zavin <dmitriyz@google.com>, Joe Perches <joe@perches.com>,
        davidb@codeaurora.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/7] Nexus One Support
Message-ID: <20110122215756.10428245@lxorguk.ukuu.org.uk>
In-Reply-To: <20110122210405.GC11960@n2100.arm.linux.org.uk>
References: <1295632828.19880.22.camel@m0nster>
	<20110121100441.06a94482@jbarnes-desktop>
	<1295633882.19880.31.camel@m0nster>
	<AANLkTi=L+MW5-KLP_TKSxhstD8JEtBW=RKci5wSbZsd6@mail.gmail.com>
	<1295642995.19880.42.camel@m0nster>
	<1295643762.25868.31.camel@Joe-Laptop>
	<1295645098.22882.1.camel@m0nster>
	<AANLkTi=mvdfpCPefGeDr+eGxpSUr3is5jgugHtgB-m1w@mail.gmail.com>
	<20110122122018.GC5194@n2100.arm.linux.org.uk>
	<AANLkTi=47z21zExtfHq2WYdUdXeC1rNhe7vQsqPkFsMi@mail.gmail.com>
	<20110122210405.GC11960@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Jan 2011 21:04:05 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Sat, Jan 22, 2011 at 11:22:57AM -0800, Brian Swetland wrote:
> > What would be useful would be a reasonable convention for
> > acknowledging multiple authors, perhaps something along the lines of:
> 
> I asked for the answer to a _specific_ example.  If you can't answer
> that example, then you *can't* expect Daniel to either, and it is
> utterly unreasonable to demand it of him.

I've always just put it in the text. I'm not fond of it being in URLs
because some day they break and move, at least if the list of names is in
the git log it's ensuring the contributor data isn't going to get
completely lost.

Yeah

Based on blah by
	name
	name
	name
	name
	name

isn't the most thrilling git commit message but it works and sometimes
you can even generate the list with grep

