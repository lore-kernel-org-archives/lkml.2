Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0KGAPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 20:15:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35848 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753860Ab0KGAPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 20:15:10 -0400
Date: Sun, 7 Nov 2010 00:13:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: david@lang.hm, Anca Emanuel <anca.emanuel@gmail.com>,
        Greg KH <greg@kroah.com>, Elvis Dowson <elvis.dowson@mac.com>,
        Janakiram Sistla <janakiram.sistla@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Forked android kernel development from linux kernel mainline
Message-ID: <20101107001341.4e39c631@lxorguk.ukuu.org.uk>
In-Reply-To: <20101107000348.GF2935@thunk.org>
References: <01784A8B-36A0-4E8A-9729-23C2B19351F8@mac.com>
	<AANLkTi=UxhRdcDaoKaYVWhPkp_e-uLF4=zhXs7gutkgx@mail.gmail.com>
	<20101106181202.GA6927@kroah.com>
	<20101106192259.GB2935@thunk.org>
	<AANLkTikQoAbsKX=N-ST3KVqSxBnA6OhNvd7FehLDnn=V@mail.gmail.com>
	<20101106234029.GC2935@thunk.org>
	<alpine.DEB.2.00.1011061646170.29342@asgard.lang.hm>
	<20101107000348.GF2935@thunk.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010 20:03:48 -0400
"Ted Ts'o" <tytso@mit.edu> wrote:

> On Sat, Nov 06, 2010 at 04:52:26PM -0700, david@lang.hm wrote:
> > also, none of these other patches resulted in device drivers
> > developed for a distro being incompatible with mainline.
> 
> What, people can't delete a couple of single lines of code before
> submitting the device driver upstream to mainline?

I've always wondered that but never seen a good answer from the Android
people as to why they don't push the stuff without the wakelock bits and
just keep "add wakelock" patches for those as they do for the core kernel
stuff they hack about.

