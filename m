Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab1I1RdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:33:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:60363 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751433Ab1I1RdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:33:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+j3Ah/CtGjQEHBKRgsCrwBouPqdbYxHQHjVypgMT
	TVs8aWaRcU4T2e
Subject: Re: x86: interrupt routing question
From: Mike Galbraith <efault@gmx.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <CAErSpo6t7D_TFjf_jQx9GG-kh-XeLD6dS1GgdTywgpM0SnXndg@mail.gmail.com>
References: <1310455620.4844.29.camel@marge.simson.net>
	 <1317194932.6506.94.camel@marge.simson.net>
	 <CAErSpo6t7D_TFjf_jQx9GG-kh-XeLD6dS1GgdTywgpM0SnXndg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 19:33:01 +0200
Message-ID: <1317231181.10997.72.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 09:26 -0600, Bjorn Helgaas wrote:
> On Wed, Sep 28, 2011 at 1:28 AM, Mike Galbraith <efault@gmx.de> wrote:
> >
> > For the next sod who gets curious about irq routing behavior difference,
> > and tries to ask google.
> 
> Thanks for following up on this!
> 
> So, having read the fine manual, do you think this is a Linux bug, or
> something that could be improved in Linux, either by changing the
> behavior or making the dmesg more informative?  It certainly cost you
> a lot of time, and it'd be nice if we could save the next person :)

It didn't take long at all after I stopped trying to ask google and
acpidump, and went to the source.  I don't think it's a bug, but I only
_started_ to RTFM, so whether it could be improved is a question I can't
begin to answer.. and kinda hope to never be able to answer :)

	-Mike

