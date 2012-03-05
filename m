Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab2CEQEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:04:42 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:54588 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755024Ab2CEQEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:04:39 -0500
Date: Mon, 5 Mar 2012 11:04:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [linux-pm] 3.3-rc6: Reported regressions from 3.2
In-Reply-To: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
Message-ID: <Pine.LNX.4.44L0.1203051056560.1847-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Mar 2012, Rafael J. Wysocki wrote:

> Bug-Entry	: https://bugzilla.kernel.org/show_bug.cgi?id=42683
> Subject		: WARN... Device 'cpu1' does not have a release() function, it is broken and must be fixed. when doing 'xl vcpu-set <guest_id> 1'
> Submitter	: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date		: 2012-01-23 18:06 (42 days old)
> Message-ID	: <20120123180601.GA24553@phenom.dumpdata.com>
> References	: http://marc.info/?l=linux-kernel&m=132734233916154&w=2

This has been fixed by commits 2885e25c422fb68208f677f944a45fce8eda2a3c
and 29bb5d4fd3140a7d5d02d858118c74a45f15c296, plus probably one more
that I can't identify.

Alan Stern

