Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2AOCF2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 21:05:28 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:42205 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab2AOCF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 21:05:27 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1201141121300.7598-100000@netrider.rowland.org>
References: <20120114144938.GA32033@suse.de>
	<Pine.LNX.4.44L0.1201141121300.7598-100000@netrider.rowland.org>
Date: Sat, 14 Jan 2012 18:05:24 -0800
X-Google-Sender-Auth: SvHqDEC1Vc1_JIJDiv_E7MLXXWg
Message-ID: <CA+8MBbJS0YNUmqOV_d6hug=FesghYay4gQGdaBX_OhYt6sbF-Q@mail.gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
From: Tony Luck <tony.luck@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 8:30 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> The driver core isn't designed to handle device structures that get
> unregistered and then spring back to life; callers are supposed to
> allocate a fresh new structure instead.

Does every caller use "kzalloc()" for this fresh new structure (or even
for the original registration) rather than "kmalloc()"?

-Tony
