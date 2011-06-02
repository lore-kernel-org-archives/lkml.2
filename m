Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab1FBKFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:05:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54366 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932138Ab1FBKFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:05:45 -0400
Date: Thu, 2 Jun 2011 11:07:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: gregkh@suse.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: tty breakage in X (Was: tty vs workqueue oddities)
Message-ID: <20110602110727.7343782b@lxorguk.ukuu.org.uk>
In-Reply-To: <1307003821.29297.77.camel@pasglop>
References: <1306999045.29297.55.camel@pasglop>
	<1307003821.29297.77.camel@pasglop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Jun 2011 18:37:01 +1000
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Thu, 2011-06-02 at 17:17 +1000, Benjamin Herrenschmidt wrote:
> > Hi Alan !
> 
> Hrm... looks like Alan is innocent ... interesting tho, the culprit
> patch looks like something he (or somebody known to understand the tty
> code :-) should have reviewed.

I did review it, and ran it and it worked beautifully on my system 8)

I do wonder if it has an interaction with Linus earlier changes to queue
flushing as I've never tested both together.

