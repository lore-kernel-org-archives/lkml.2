Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab0EZWME (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:12:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44777 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab0EZWMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:12:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Thu, 27 May 2010 00:13:21 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, James Bottomley <James.Bottomley@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Arve Hj?nnev?g" <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu
References: <1274863342.5882.4850.camel@twins> <20100526165919.GB2089@elf.ucw.cz> <1274893309.1674.1773.camel@laptop>
In-Reply-To: <1274893309.1674.1773.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270013.21412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010, Peter Zijlstra wrote:
> On Wed, 2010-05-26 at 18:59 +0200, Pavel Machek wrote:
> > On Wed 2010-05-26 18:28:28, Peter Zijlstra wrote:
> > > On Wed, 2010-05-26 at 11:18 -0500, James Bottomley wrote:
> > > > > Or make the suspend manager a C proglet and provide a JNI interface,
> > > > > or whatever.
> > > > 
> > > > It's a fairly large piece of code to try to rewrite in C, so I don't
> > > > think that's feasible on a reasonable timescale.  Android does have the
> > > > concept of special sockets that can be used to communicate from less to
> > > > more privileged processes (it has a very segmented runtime model), so
> > > > these might be usable ... they have a drawback that they're essentially
> > > > named pipes, so no multiplexing, but one per suspend influencing C
> > > > process shouldn't be a huge burden. 
> > > 
> > > It wouldn't need to convert the whole Frameworks layer into C, just
> > > enough to manage the suspend state.
> > > 
> > > Anyway, I think there's been enough arguments against even the concept
> > > of opportunistic/auto-suspend, and I for one will object with a NAK if
> > > Rafael send this to Linus.
> > 
> > It was submitted already. I tried to followup with NAK, but can't
> > currently see it in the archive.
> 
> It was apparently hidden on some funky list. Hiding pull requests is bad
> enough, but hiding pull requests for contended features is just plain
> wrong.

It was not intentionally hidden.  I think my mailer did that wrong because
the CC list was too long or something like this.  I surely intended to send
it to the LKML, so sorry for the inconvenience.

Rafael
