Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab2KCOpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:45:53 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:37517 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2KCOpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:45:52 -0400
Date: Sat, 3 Nov 2012 14:50:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121103145052.0da49071@pyramind.ukuu.org.uk>
In-Reply-To: <50951A0E.9010103@redhat.com>
References: <20121025180045.GL11442@htj.dyndns.org>
	<1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
	<20121031212241.GZ2945@htj.dyndns.org>
	<5093DD5E.6030808@redhat.com>
	<20121102165123.GB3823@mtj.dyndns.org>
	<509407B7.3030904@redhat.com>
	<20121102175350.GB27843@mtj.dyndns.org>
	<50951A0E.9010103@redhat.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's not really about the lines of code.  It adds a new userland
> > visible interface.  As for the "long" list of commands, it depends on
> > how you write it but even if it's textually long it's still very
> > simple in terms of actual complexity.
> 
> Sure, but its place is not the kernel.
> 
> As to implementing the ioctl, it's all but trivial.  For one thing, you
> have to make the block device ioctl op take a "struct file".  I have
> been asking Al Viro about it for 6 months and I haven't got any answer yet.

Just do it - if Al cared he'd have replied about it.

> I proposed a way to implement the ultimately flexible solution (BPF) and
> you shot it down because it was too complex.  Alan is showing you with
> multiple examples of why the flexibility would be useful (perhaps nobody
> would use it, but the use cases _are_ there), and you are mostly
> ignoring them.

My feeling too - It feels to me like Tejun is trying to railroad a broken
non-solution into the system without regards for anyone else and by
simply dismissing any other input.

Alan
