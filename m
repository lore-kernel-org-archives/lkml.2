Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab1LMNz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:55:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59744 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab1LMNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:55:25 -0500
Subject: Re: [PATCH 1/4] PM / Sleep: Make pm_op() and pm_noirq_op() return
 callback pointers
From: Namhyung Kim <namhyung@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Russell King <linux@arm.linux.org.uk>,
        Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <201112130053.37714.rjw@sisk.pl>
References: <201112100018.38536.rjw@sisk.pl>
	 <201112100020.00368.rjw@sisk.pl> <loom.20111212T041314-709@post.gmane.org>
	 <201112130053.37714.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 22:55:16 +0900
Message-ID: <1323784516.1455.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-12-13 (화), 00:53 +0100, Rafael J. Wysocki:
> On Monday, December 12, 2011, Namhyung Kim wrote:
> > Rafael J. Wysocki <rjw <at> sisk.pl> writes:
> > 
> > > 
> > > From: Rafael J. Wysocki <rjw <at> sisk.pl>
> > > 
> > > Make the pm_op() and pm_noirq_op() functions return pointers to
> > > appropriate callbacks instead of executing those callbacks and
> > > returning their results.
> > > 
> > > This change is required for a subsequent modification that will
> > > execute the corresponding driver callback if the subsystem
> > > callback returned by either pm_op(), or pm_noirq_op() is NULL.
> > > 
> > 
> > Hello Rafael,
> > 
> > How about typedef'ing something like pm_callback_t for readability?
> > 
> >    typedef int (*pm_callback_t)(struct device *);
> > 
> > This way, the code will be easier to read.
> 
> Do you mean something like in the patch below?  It does look a bit simpler.
> 

Yes, indeed. The patch looks better to me. :)

Thanks,
Namhyung Kim



