Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab2GXLTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 07:19:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45796 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2GXLTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 07:19:23 -0400
Date: Tue, 24 Jul 2012 12:23:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tingwei liu <tingw.liu@gmail.com>
Cc: linux-kernel@vger.kernel.org, dhillf@gmail.com
Subject: Re: Suse 11 SP1 kernel panic on HP hardware
Message-ID: <20120724122309.66312b08@pyramind.ukuu.org.uk>
In-Reply-To: <CA+qZnSSazFWLKq5ao51JX=H-NCbwLD=6ypGXOeqQF72s7ZbTVA@mail.gmail.com>
References: <CA+qZnSRNAAN6erat3Umuk6U9VYuc5SiQYK6PL8bHYAOcQ+SnAw@mail.gmail.com>
	<CA+qZnSS2N4QZ13qATNFCbhJ6BRy4ZfpEBur45OUkuggPxYe4qA@mail.gmail.com>
	<20120724115300.070d0ef7@pyramind.ukuu.org.uk>
	<CA+qZnSSazFWLKq5ao51JX=H-NCbwLD=6ypGXOeqQF72s7ZbTVA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2012 18:56:30 +0800
tingwei liu <tingw.liu@gmail.com> wrote:

> On Tue, Jul 24, 2012 at 6:53 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Tue, 24 Jul 2012 18:39:20 +0800
> > tingwei liu <tingw.liu@gmail.com> wrote:
> >
> >> Suse 11 SP1 kernel panic。
> >>
> >> I can't debug it without debuginfo. Who can give me a link of sels
> >> 2.6.32.12-0.7.default.debug or give some advise.
> >
> > For distribution kernels (which tend to contain lots of other patches)
> > it is best to talk to your distribution support as a starter and/or their
> > forums.
> >
> I have report bug on suse website, but I haven't got any response until now!
> Can you give some advice?
> I thought this maybe a kernel bug.

It may well be a bug in the SuSE provided kernel. In which case you need
to deal with SuSE or the SuSE forums. If you can reproduce it with a
modern upstream kernel (eg 3.2 or 3.4) rather than a SuSE one then we
might have an interest.

Alan
