Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab2KEUHP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:07:15 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40047 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab2KEUHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:07:13 -0500
Date: Mon, 5 Nov 2012 20:12:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
        Petr Matousek <pmatouse@redhat.com>, Kay Sievers <kay@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: setting up CDB filters in udev (was Re: [PATCH v2 0/3] block:
 add queue-private command filter, editable via sysfs)
Message-ID: <20121105201208.2ea500cc@pyramind.ukuu.org.uk>
In-Reply-To: <20121105181809.GE19354@mtj.dyndns.org>
References: <20121025180045.GL11442@htj.dyndns.org>
	<1657557410.1945557.1351190120407.JavaMail.root@redhat.com>
	<20121031212241.GZ2945@htj.dyndns.org>
	<5093DD5E.6030808@redhat.com>
	<20121102165123.GB3823@mtj.dyndns.org>
	<509407B7.3030904@redhat.com>
	<20121102175350.GB27843@mtj.dyndns.org>
	<50951A0E.9010103@redhat.com>
	<20121103145052.0da49071@pyramind.ukuu.org.uk>
	<20121105181809.GE19354@mtj.dyndns.org>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> To me, it feels like you guys are pushing a feature without strong
> enough use case.  So, I'm still pretty strongly against it.

A feature people have been asking for repeatedly for ten years. Go scan
the archive. I'm also pushing for a *generic* do it once solution so we
never have to have the debate again regardless of what media pops up in
future.

There are two sensible choices here IMHO

- The simple sysctl

- Doing the job right

A half way solution such as that you are proposing seems to me to achieve
nothing other than guaranteeing we'll have another pile of useless crap
to maintain forever as ABI.

Alan
