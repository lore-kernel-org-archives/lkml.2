Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab2JELVD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 07:21:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56440 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2JELVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 07:21:01 -0400
Date: Fri, 5 Oct 2012 12:25:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@amd64.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Joe Perches <joe@perches.com>
Subject: Re: tty_init_dev: 24 callbacks suppressed
Message-ID: <20121005122542.4574f656@pyramind.ukuu.org.uk>
In-Reply-To: <506EC1AE.6000201@suse.cz>
References: <20121004092055.GA21028@aftab.osrc.amd.com>
	<20121004112347.GA245@x4>
	<20121004115157.GA245@x4>
	<20121004124025.GC21028@aftab.osrc.amd.com>
	<20121004131101.GA245@x4>
	<506EC1AE.6000201@suse.cz>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Actually this is Joe's version of the patch. Joe, people started hitting
> the bug [1]. Could you resend your patch?
> 
> [1] https://patchwork.kernel.org/patch/1339221/
> 
> BTW what scares me that nobody noticed that bug until this is in the
> Linus's tree. Do people use -next at all or am I the only one user? (I
> didn't hit it as I have the patch in my local queue.)

I run -next for various things. I'd noticed that funny but you'd started
investigating it before I got to investigating.

Alan
