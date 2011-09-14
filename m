Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab1INSmK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:42:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49143 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757325Ab1INSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:42:07 -0400
Date: Wed, 14 Sep 2011 19:40:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: doug@easyco.com
Cc: Boaz Harrosh <bharrosh@panasas.com>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org, nab@linux-iscsi.org,
        ryanh@us.ibm.com
Subject: Re: [PATCH 1/2] block: export __make_request
Message-ID: <20110914194040.37ed38c9@lxorguk.ukuu.org.uk>
In-Reply-To: <CAFx4rwR=EnCVfi4Pzm9pmTtKWAdzvzOg7wwzBbzZN7YTvu5-fw@mail.gmail.com>
References: <20110911145053.GA28996@infradead.org>
	<4E6DD7F0.8020903@kernel.dk>
	<20110912122507.GA12229@infradead.org>
	<4E6DFA8C.3030400@kernel.dk>
	<20110912133826.GA22548@infradead.org>
	<4E6E49BE.6020005@kernel.dk>
	<20110913211911.GA13894@infradead.org>
	<4E70E1C1.8040907@panasas.com>
	<CAFx4rwR=EnCVfi4Pzm9pmTtKWAdzvzOg7wwzBbzZN7YTvu5-fw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Sep 2011 10:53:22 -0700
Doug Dumitru <doug@easyco.com> wrote:

> It would be great if this function were exported, but I would
> encourage everyone to consider exporting it generally, not just for
> GPL usage.

That would require a licensing change for the kernel. The kernel is a GPL
work. Some of us have not licensed it in any other way.

> 
> The kernel seems to be pretty clean that some subsystems are GPL only
> (things like sysfs), and some are open 

The _GPL is meant to make it clear they are internal symbols. The lack of
an _GPL does not make them usable by non GPL code, it merely indicates
that its perhaps more likely that you could in some cases shown something
was not a derivative work.

The licensing is determined by the license document, and that very
clearly says the boundary is derivative works. The rest is just vague
guidance.

In addition btw please be careful when trying to do this even with non
derivative code your lawyer is happy with. The kernel contains algorithms
which are subject to various US software patent mess where GPL use has
been granted, that may impact you if you use such code indirectly in non
GPL code.

Alan
