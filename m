Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab2HPStM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:49:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49460 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2HPStJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:49:09 -0400
Date: Thu, 16 Aug 2012 19:53:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tomas Racek <tracek@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: x86, nops settings result in kernel crash
Message-ID: <20120816195324.5356cba0@pyramind.ukuu.org.uk>
In-Reply-To: <1898701172.1847948.1345142715802.JavaMail.root@redhat.com>
References: <20120816134834.GA11974@x1.osrc.amd.com>
	<1898701172.1847948.1345142715802.JavaMail.root@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012 14:45:15 -0400 (EDT)
Tomas Racek <tracek@redhat.com> wrote:

> ----- Original Message -----
> > On Thu, Aug 16, 2012 at 09:35:12AM -0400, Tomas Racek wrote:
> > > Hi,
> > > 
> > > I am writing a file system test which I execute in qemu with kernel
> > > compiled from latest git sources and running it causes this error:
> > > 
> > > https://bugzilla.kernel.org/show_bug.cgi?id=45971
> > > 
> > > It works with v3.5, so I ran git bisect which pointed me to:
> > > 
> > > d6250a3f12edb3a86db9598ffeca3de8b4a219e9 x86, nops: Missing break
> > > resulting in incorrect selection on Intel
> > > 
> > > To be quite honest, I don't understand this stuff much but I tried
> > > to do some debugging and I figured out (I hope) that the crash is
> > > caused by setting ideal_nops to p6_nops (k8_nops was used before
> > > the break statement was added).
> > 
> > Maybe I overlooked it or maybe it was implied but did you try
> > reverting
> > the patch and rerunning your test? Does it work ok then?
> > 
> 
> Yes, if I remove the break statement (introduced by this commit), it works fine.

What version of qemu is this - do we have qemu bug here I wonder.

Alan
