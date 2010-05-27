Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab0E0VXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:23:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56743 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932175Ab0E0VXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:23:07 -0400
Date: Thu, 27 May 2010 22:29:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul@smtp1.linux-foundation.org" <Paul@smtp1.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100527222957.7f39b5af@lxorguk.ukuu.org.uk>
In-Reply-To: <201005272315.28475.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1005271303190.3239-100000@iolanthe.rowland.org>
	<alpine.LFD.2.00.1005271924170.3032@localhost.localdomain>
	<201005272315.28475.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well, what about when I want the machine to suspend _regardless_ of whether
> or not it's idle at the moment?  That actually happens quite often to me. :-)

I don't think it helps to combine them for this discussion ?

> I don't see much difference between that and ACPI S3 other than the memory
> contents are preserved in S3.  It also is complete power off state - except for
> memory refresh and wakeup sources (which also may be active in S4).

Agreed although I am pushed to think of many real world cases where it
might matter. VM's maybe?

Alan
