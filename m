Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab1GBTbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 15:31:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49960 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752895Ab1GBTbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 15:31:23 -0400
Date: Sat, 2 Jul 2011 20:33:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, Vasiliy Kulikov <segoon@openwall.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110702203323.03462aef@lxorguk.ukuu.org.uk>
In-Reply-To: <20110702164243.GB26232@openwall.com>
References: <20110626194618.GA21740@elte.hu>
	<20110626202518.GA4915@albatros>
	<20110626220126.GA24004@elte.hu>
	<20110627083633.GA5846@albatros>
	<20110627104058.45e93c41@pyx>
	<20110627183829.GA16033@albatros>
	<BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
	<20110701120059.GL20990@elte.hu>
	<20110701125411.GA21551@albatros>
	<20110701152051.763fd594@lxorguk.ukuu.org.uk>
	<20110702164243.GB26232@openwall.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Your syslog daemon appears to need improvement
> 
> syslogd definitely should (and does) perform escaping of control chars
> for logs written through it.
> 
> > and that would be the right fix for dmesg etc.
> 
> How?  We can't realistically expect everyone to stop invoking dmesg
> directly.  Moreover, this is sometimes useful, although someone who is

No but you could make "dmesg" do filtering.

Alan
