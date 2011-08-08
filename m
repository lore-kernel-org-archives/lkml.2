Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab1HHRzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:55:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44541 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1HHRzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:55:52 -0400
Subject: Re: [PATCH] jump label: Reduce the cycle count by changing the link
 order
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>, rostedt@goodmis.org, pjt@google.com,
        mingo@elte.hu, rth@redhat.com, linux-kernel@vger.kernel.org
Date: Mon, 08 Aug 2011 19:55:33 +0200
In-Reply-To: <CACqU3MVE4ZURooWfHDTjJ9c=VG17FNXnq6X_HBZ3+DkZeoBXJg@mail.gmail.com>
References: <20110805204040.GG2522@redhat.com>
	 <1312582209.28695.51.camel@twins> <20110808154027.GA4336@redhat.com>
	 <CACqU3MVE4ZURooWfHDTjJ9c=VG17FNXnq6X_HBZ3+DkZeoBXJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1312826133.22367.22.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-08 at 13:52 -0400, Arnaud Lacombe wrote:
> >> Also, pjt mentioned on IRC that mucking about with link order is
> >> something google is not unfamiliar with.. could we use some sort of
> >> runtime feedback to generate linker layout maps or so? That seems like a
> >> more scalable version than randomly mucking about with Makefiles :-)
> >
> > Agreed. Definitely a good area to research. However, until we have that done, I
> > think this patch makes sense.
> >
> this might be a dumb question as I do not know much about that, but
> couldn't hot code be put in their own section ? 

Ah, but what is the hot code? The whole problem statement is finding
that.
