Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394Ab2EQRTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:19:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49057 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495Ab2EQRTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:19:42 -0400
Date: Thu, 17 May 2012 18:22:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 0/5] Delete microchannel [CONFIG_MCA] support
Message-ID: <20120517182232.2d0dd540@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFxRjxf_3hka_SSqC+p32aDMU=0rq0_RaceO=bQqmtO2xg@mail.gmail.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
	<CA+55aFxRjxf_3hka_SSqC+p32aDMU=0rq0_RaceO=bQqmtO2xg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012 09:53:16 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, May 17, 2012 at 9:40 AM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
> > It was good that we could support MCA machines back in the day, but
> > realistically, nobody is using them anymore.
> 
> Yeah, I think I can ack this. Looks like 3.5 will be a nice "remove
> stupid hardware support" release.

I have a PS/2 in the cellar if anyone needs one 8)

But yes I think the MCA bus code (and the PS/2 in the cellar) can both go.
