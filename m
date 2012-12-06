Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2LFTta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:49:30 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55429 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2LFTt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:49:29 -0500
Date: Thu, 6 Dec 2012 19:54:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Cong Ding <dinggnu@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bin Wang <wbin00@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC -next] Fix the trailing blank space issue
Message-ID: <20121206195448.1ff18422@pyramind.ukuu.org.uk>
In-Reply-To: <20121206163138.GC2510@gmail.com>
References: <1354784936-5647-1-git-send-email-wbin00@gmail.com>
	<20121206154219.GA24788@gmail.com>
	<20121206160606.GA15256@kroah.com>
	<20121206163138.GC2510@gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would suggest to write a series of scripts. And then announce a date
> (preferably some holiday like Xmas) to run these scripts. The announce is to
> avoid conflicts with other developers. It will save both developers' and
> subsystem maintains' time, do you agree?

And if any of them are wrong how will we notice ?

By all means generate them in subsystem sized chunks but they do need to
get a human glance just to be sure. If you send me drivers/tty for
example I'll go over it happily and give it an Ack unless something is
very odd.

And to be honest if they don't all get done - who cares. There are a
several thousand more serious things the scanning and analyser tools flag
that are much more useful to fix.

Alan
