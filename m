Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933615Ab0JRX7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:59:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33207 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932867Ab0JRX7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:59:36 -0400
Date: Tue, 19 Oct 2010 00:58:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Miller <davem@davemloft.net>
Cc: paul.gortmaker@windriver.com, luca@llucax.com.ar, jon.maloy@ericsson.com,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Linux 2.6.35/TIPC 2.0 ABI breaking changes
Message-ID: <20101019005819.24c8d373@lxorguk.ukuu.org.uk>
In-Reply-To: <20101018.151708.193712688.davem@davemloft.net>
References: <20101018150422.GV8781@llucax.com.ar>
	<20101018184628.GX8781@llucax.com.ar>
	<AANLkTimKbOreV4Fuyw3TbCrk9aa5yBZQSuRbo3Vdx=Q1@mail.gmail.com>
	<20101018.151708.193712688.davem@davemloft.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 15:17:08 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Paul Gortmaker <paul.gortmaker@windriver.com>
> Date: Mon, 18 Oct 2010 16:42:33 -0400
> 
> > If you have access to the user space code in question, you can just
> > switch behaviour semantics based on the results of a uname call, knowing
> > that this change was included in versions since approx last Feb.  There
> > is also /proc/version which can be parsed manually if you prefer.
> 
> Requiring userspace to check kernel versioning information in order
> to user an exported userspace API correctly is _ALWAYS_ _WRONG_.
> 
> You cannot and must not make backwards incompatible changes to
> userspace interfaces.
> 
> Really, you can't.

In which case given that most distros are shipping older stuff and care
about ABI stability presumably the bug should get fixed for 2.6.36 ?
