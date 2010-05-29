Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab0E2PC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 11:02:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34001 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755826Ab0E2PCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 11:02:55 -0400
Date: Sat, 29 May 2010 16:09:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100529160915.051ab19f@lxorguk.ukuu.org.uk>
In-Reply-To: <AANLkTimyLsldXoZ_egjybwS9kE_OcxsOuZwC0F-C2HjY@mail.gmail.com>
References: <20100529131810.5bb51bdd@schatten.dmk.lab>
	<Pine.LNX.4.44L0.1005290941060.30763-100000@netrider.rowland.org>
	<AANLkTimyLsldXoZ_egjybwS9kE_OcxsOuZwC0F-C2HjY@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could we have write(powerstate_fd, "qos",3) block until all
> QOS_EVENTUALLY constraints are lifted or the system successfully
> suspends and resumes or a signal arrives?

Yes - and you can then use alarm() or similar to do timeouts (or write
the timeout to the fd ?)

