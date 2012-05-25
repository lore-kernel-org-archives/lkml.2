Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2EYNjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:39:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60205 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab2EYNjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:39:06 -0400
Date: Fri, 25 May 2012 14:42:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: remove recursive implementation of
 tty_ldisc_release
Message-ID: <20120525144206.23dcdaa7@pyramind.ukuu.org.uk>
In-Reply-To: <CA+1xoqcwM7j3K_UNKNcHOQKthi3N8r5FJtc-XsXK-BOcKE3Lmw@mail.gmail.com>
References: <20120525111152.7239.99793.stgit@bob.linux.org.uk>
	<CA+1xoqcwM7j3K_UNKNcHOQKthi3N8r5FJtc-XsXK-BOcKE3Lmw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012 13:13:15 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> On Fri, May 25, 2012 at 1:11 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > From: Alan Cox <alan@linux.intel.com>
> >
> > We need to do this in one pass with the locking requirements we now
> > have.
> >
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> 
> I don't see any lockdep warnings anymore with this patch applied on
> top of all others.

Yay thanks for reporting/testing
