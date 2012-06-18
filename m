Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2FRKEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:04:45 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33880 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2FRKEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:04:44 -0400
Date: Mon, 18 Jun 2012 11:08:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John <jhnlmn@yahoo.com>
Cc: linux-kernel@vger.kernel.org, eparis@redhat.com, akpm@linux-foundation.org
Subject: Re: What is the status of fanotify bugs? (ENOMAINTAINER ?)
Message-ID: <20120618110825.2a996a49@pyramind.ukuu.org.uk>
In-Reply-To: <1339992170.35835.YahooMailClassic@web113213.mail.gq1.yahoo.com>
References: <1339992170.35835.YahooMailClassic@web113213.mail.gq1.yahoo.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2012 21:02:50 -0700 (PDT)
John <jhnlmn@yahoo.com> wrote:

> Hi,
> I googled and found at least 2 fanotify bugs,
> which were discussed and patches were submitted but never merged into the kernel:
> 
> 1. This one is more than 2 years old. Seems to be an obvious bug:
> http://groups.google.com/group/linux.kernel/browse_thread/thread/46b25f4dfc96d811
> 
> 2. This discussion was abruptly terminated last year:
> http://groups.google.com/group/linux.kernel/browse_thread/thread/5e21ff2b0c446b69
> 

There are some in kernel bugzilla (including the fanotify is blind
to sendfile flaw).

> And I have another problem, which is a complete show stopper for me:
> fsnotify/fanotify do not pass file/directory  creation/deletion events
> when working in FAN_MARK_MOUNT mode.
> I was hoping to get notified about file system changes, but it appears to be impossible.
> A directory with many subdirectories can be deleted and fsnotify/fanotify completely ignore this event.
> 
> So, I wonder whether fsnotify/fanotify framework is still being maintained and used by anybody.
> If nobody else cares about it, then I will need to make my own file system notification hook.
> But, of course, it would be better to fix fsnotify/fanotify so that I can avoid maintaining my own notification code.
> 
> What do you think?

At this point I would say that it's time to consider declaring the
maintainer apparently overloaded and not functional (Eric clearly isn't
absent given all the SELinux patches currently appearing).

If he doesn't respond to this discussion I would send your changes to
Andrew Morton <akpm@linux-foundation.org>, and if you've got a moment or
the inclination to check and review/merge the other two outstanding bits
you've flagged even better.

Alan
