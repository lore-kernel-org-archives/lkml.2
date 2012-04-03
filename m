Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2DCWel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:34:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55410 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2DCWek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 18:34:40 -0400
Date: Wed, 4 Apr 2012 00:34:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent crash on missing sysfs attribute group
Message-ID: <20120403223435.GC10161@gmail.com>
References: <1333403193.2960.80.camel@laptop>
 <20120403060252.GA27084@gmail.com>
 <20120403081735.78ca3bb3@pluto.restena.lu>
 <m1d37pgugy.fsf@fess.ebiederm.org>
 <20120403071543.GA17502@gmail.com>
 <m1r4w5dzjq.fsf@fess.ebiederm.org>
 <20120403080410.GF26826@gmail.com>
 <m1sjgl9ozd.fsf@fess.ebiederm.org>
 <20120403101623.GA16889@gmail.com>
 <m18vid6qkb.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18vid6qkb.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> > This has no relevance to the bug and crash pattern itself 
> > whatsoever, so stop blathering about unrelated things.
> 
> Crashing or BUG_ON or WARN_ON has no relevance to how hard it 
> is to debug this. [...]

Erm, so you think the difference between a nice WARN_ON() and a 
machine that *DOES NOT BOOT* is irrelevant?

In which universe? Smoking what kind of drugs?

Seriously, you need a reality check. We settled the BUG_ON() 
versus WARN_ON() debate about a decade ago, in favor of 
WARN_ON().

Thanks,

	Ingo
