Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0FVGSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 02:18:45 -0400
Received: from ist.d-labs.de ([213.239.218.44]:47786 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab0FVGSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 02:18:44 -0400
Date: Tue, 22 Jun 2010 08:18:03 +0200
From: Florian Mickler <florian@mickler.org>
To: markgross@thegnar.org
Newsgroups: gmane.linux.kernel
Cc: 640e9920@gmail.com, Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?ISO-8859-15?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100622081803.4d472542@schatten.dmk.lab>
In-Reply-To: <20100622015837.GC12795@gvim.org>
References: <20100621055522.GE9735@gvim.org>
	<Pine.LNX.4.44L0.1006211125470.1687-100000@iolanthe.rowland.org>
	<20100622015837.GC12795@gvim.org>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010 18:58:37 -0700
mark gross <640e9920@gmail.com> wrote:


> wrong.  They are about 1) adding opportunistic suspend, and 2) adding
> critical sections to block suspend.  
> 
> No race issues where ever talked about until alternative solutions
> where put up.

The whole and only reason to even define the term "critical sections" is
when you need to define "a race". Or vice versa. A race is prevented by
defining critical sections and protecting these against concurrent
access.

[..snip..]

[some rant that alan is not familiar with android userspace..]

Are you suggesting that only android developers are supposed to talk
about this? 

This is a pretty basic thing. It has only to do with system suspend.
(And using system suspend aggressively)

> 
> --mgross
> 

Cheers,
Flo
