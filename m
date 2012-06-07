Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184Ab2FGRXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:23:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48422 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab2FGRXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:23:10 -0400
Date: Thu, 7 Jun 2012 18:26:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Weinberger <richard@nod.at>
Cc: Alan Cox <alan@linux.intel.com>, Boaz Harrosh <bharrosh@panasas.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jslaby@suse.cz
Subject: Re: [uml-devel] um: TTY fixes (?)
Message-ID: <20120607182615.39877547@pyramind.ukuu.org.uk>
In-Reply-To: <4FD0D9AF.4000605@nod.at>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
	<4FCF6748.6020005@panasas.com>
	<4FD059AC.8050808@panasas.com>
	<4FD06A22.6040002@nod.at>
	<4FD07F14.50902@panasas.com>
	<4FD0802A.1020203@nod.at>
	<20120607115227.6643d1ad@pyramind.ukuu.org.uk>
	<4FD0C64D.2050302@nod.at>
	<20120607173711.22ae146f@bob.linux.org.uk>
	<4FD0D7AA.4010506@nod.at>
	<20120607175024.696be664@bob.linux.org.uk>
	<4FD0D9AF.4000605@nod.at>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What about the not nice ways?
> Having a ugly driver until 3.7 is better than having no driver...

If you are willing to go do the work then yes.

> I'm wondering why does drivers/tty/vt/vt.c work?
> Can't I model the UML driver after it?

Possibly although the vt driver has its own locking model to watch out
for.

Alan
