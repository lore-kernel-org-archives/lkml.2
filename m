Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0HNDTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 23:19:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49006 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab0HNDTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 23:19:08 -0400
Date: Sat, 14 Aug 2010 13:18:45 +1000
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Brian Swetland <swetland@google.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Alan Stern <stern@rowland.harvard.edu>,
        paulmck@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        david@lang.hm, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, peterz@infradead.org, tglx@linutronix.de,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100814131845.58544209@notabene>
In-Reply-To: <201008131707.03484.rjw@sisk.pl>
References: <AANLkTikcoWfmL-XfYbFeYdVtU9GC6_LtVSSB2H6GcedA@mail.gmail.com>
	<201008130528.21887.rjw@sisk.pl>
	<AANLkTinMmVdAVaCFXyDZpVRmZ9FCWYhtdeM=o4hdoZnT@mail.gmail.com>
	<201008131707.03484.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Aug 2010 17:07:02 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> > 
> > There is no absolute need to start the suspend process from within the
> > kernel, but it makes the user space code much simpler for what we
> > need.  
> 
> I'm entirely aware of that.  Still, I think user space is the right place to
> initiate system suspend.
> 

For what it's worth - I completely agree.

Clearly there is no a lot of unanimity on this, and so lots of room to
experiment with different approaches.  It's best if we leave as much as
possible of that experimentation in user-space - just have the kernel do what
cannot be done elsewhere.

NeilBrown
