Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab1LEO33 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 09:29:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46776 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932188Ab1LEO32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 09:29:28 -0500
Date: Mon, 5 Dec 2011 14:30:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        alan@linux.intel.com, alek.du@intel.com, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86,mrst: Power control commands update
Message-ID: <20111205143049.0581a8ed@lxorguk.ukuu.org.uk>
In-Reply-To: <20111205135634.GA23719@elte.hu>
References: <tip-48bc5562103412590e4487b666b49e7b6c84ba44@git.kernel.org>
	<20111205135634.GA23719@elte.hu>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Dec 2011 14:56:34 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com> wrote:
> 
> > Commit-ID:  48bc5562103412590e4487b666b49e7b6c84ba44
> > Gitweb:     http://git.kernel.org/tip/48bc5562103412590e4487b666b49e7b6c84ba44
> > Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
> > AuthorDate: Wed, 16 Nov 2011 16:07:22 +0000
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 5 Dec 2011 12:42:11 +0100
> > 
> > x86,mrst: Power control commands update
> > 
> > On the Intel MID devices SCU commands are issued to manage power
> > off and the like. We need to issue different ones for
> > non-Lincroft based devices.

Looks like a missing SFI dependancy - - will take a look how you got MRST
but not SFI enabled.
