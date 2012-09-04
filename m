Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab2IDVfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 17:35:18 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43736 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab2IDVfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 17:35:15 -0400
Date: Tue, 4 Sep 2012 22:39:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH 07/11] kexec: Disable in a secure boot environment
Message-ID: <20120904223957.50f6a3b9@pyramind.ukuu.org.uk>
In-Reply-To: <87r4qhwkx9.fsf@xmission.com>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
	<1346774117-2277-8-git-send-email-mjg@redhat.com>
	<87txvdzgur.fsf@xmission.com>
	<20120904202205.GA28903@srcf.ucam.org>
	<87r4qhwkx9.fsf@xmission.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, given that approximately everyone will be booting under EFI within 
> > 18 months, treating it as a niche case seems a little short sighted.

Actually the majority of Linux devices are not PCs 8)

> > secondly, there are already several non-EFI platforms that want to enact 
> > a policy preventing root from being able to arbitrarily replace the 
> > kernel. Given that people are doing this in the wild, it makes sense to 
> > move towards offering that policy in the mainline kernel.
> 
> Either this code makes sense without an appeal to EFI or this code makes
> no sense.

Yes - and the capability is I think the right starting point (although
you'll never make any OS locked down this way even if you are not in fact
violating the GPLv2 license by doing so, which I suspect will be the case
for some implementations)

> So please rework this to come from an angle that makes sense all by
> itself.

I think it needs to be defined in terms of what the capability is
supposed to guarantee. I have a feeling Matthew has a pretty clear idea
about that in his head so can nail it fairly precisely ?

Alan
