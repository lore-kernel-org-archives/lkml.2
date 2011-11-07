Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab1KGXnH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:43:07 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58829 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755121Ab1KGXnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:43:04 -0500
Date: Mon, 7 Nov 2011 23:43:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Davidlohr Bueso <dave@gnu.org>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC PATCH] tmpfs: support user quotas
Message-ID: <20111107234337.1dc9d612@lxorguk.ukuu.org.uk>
In-Reply-To: <20111107230712.GA25769@tango.0pointer.de>
References: <1320614101.3226.5.camel@offbook>
	<20111107112952.GB25130@tango.0pointer.de>
	<1320675607.2330.0.camel@offworld>
	<20111107135823.3a7cdc53@lxorguk.ukuu.org.uk>
	<CAPXgP117Wkgvf1kDukjWt9yOye8xArpyX29xx36NT++s8TS5Rw@mail.gmail.com>
	<20111107225314.0e3976a6@lxorguk.ukuu.org.uk>
	<20111107230712.GA25769@tango.0pointer.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011 00:07:12 +0100
Lennart Poettering <mzxreary@0pointer.de> wrote:

> On Mon, 07.11.11 22:53, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> 
> > Per user would be quota, per process would be rlimit. Quite simple
> > really, nice standard interfaces we've had for years. Various systems
> 
> Uh, have you ever really looked at resource limits? Some of them are
> per-user, not per-process, i.e. RLIMIT_NPROC. And this would just be
> another one.

NPROC is a bit of an oddity.

And the standards have no idea how a resource limit hit for an fs would
be reported, nor how an app installer would check for it. Quota on the
other hand is defined behaviour.

