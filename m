Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab2DMMJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:09:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:60894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab2DMMJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:09:23 -0400
Date: Fri, 13 Apr 2012 13:11:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 12
Message-ID: <20120413131145.1fd00f1d@pyramind.ukuu.org.uk>
In-Reply-To: <20120412142415.564710b8.akpm@linux-foundation.org>
References: <20120412145931.9ec6f2b51655071795d60d1d@canb.auug.org.au>
	<20120412142415.564710b8.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 14:24:15 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 12 Apr 2012 14:59:31 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> 
> This isn't working for me.  Some time between April 3 and April 12
> someone merged something into the non-mm part of linux-next which broke
> ssh.

You are getting further than me  - on 32bit -next of the 12th explodes
with random userspace crashes in init or similar early code.

Alan
