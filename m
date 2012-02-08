Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2BHAOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 19:14:08 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56996 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab2BHAOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 19:14:05 -0500
Date: Wed, 8 Feb 2012 00:15:19 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Szabolcs Szakacsits <szaka@tuxera.com>,
        Janne =?ISO-8859-1?B?S2FsbGlvbeRr?= =?ISO-8859-1?B?aQ==?= 
	<janne@tuxera.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Direct i/o changes break all non-GPL file systems
Message-ID: <20120208001519.501b6fea@pyramind.ukuu.org.uk>
In-Reply-To: <92291682-5422-4AE2-9608-97775603E7FD@tuxera.com>
References: <92291682-5422-4AE2-9608-97775603E7FD@tuxera.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012 00:07:15 +0000
Anton Altaparmakov <anton@tuxera.com> wrote:

> Hi Linus, Andrew, Christoph,
> 
> With kernel 3.1, Christoph removed i_alloc_sem and replaced it with calls (namely inode_dio_wait() and inode_dio_done()) which are EXPORT_SYMBOL_GPL() thus they cannot be used by non-GPL file systems and further inode_dio_wait() was pushed from notify_change() into the file system ->setattr() method but no non-GPL file system can make this call.

I'm advised by my lawyer that when this occurs that I should always
inform the other party the following

"For a Linux kernel containing any code I own the code is under the GNU
public license v2 (in some cases or later), I have never given permission
for that code to be used as part of a combined or derivative work which
contains binary chunks. I have never said that modules are somehow
magically outside the GPL and I am doubtful that in most cases a work
containing binary modules for a Linux kernel is compatible with the
licensing, although I accept there may be some cases that it is."



So unless your code is remarkably non-derivative I don't see that
anything has changed.
