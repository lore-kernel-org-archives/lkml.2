Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2DCQ1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:27:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56101 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752328Ab2DCQ1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:27:10 -0400
Message-ID: <1333470428.26079.39.camel@joe2Laptop>
Subject: Re: [PATCH] printk(): add KERN_CONT where needed
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Date: Tue, 03 Apr 2012 09:27:08 -0700
In-Reply-To: <CAPXgP13--R6M3FAJ8QCB50eVTo7M9A30OW3rwwV3gv1QEtpBaQ@mail.gmail.com>
References: <1333415903.860.0.camel@mop>
	 <1333420612.26079.6.camel@joe2Laptop>
	 <CAPXgP12jX37GLgMJQuDYEi6q5A2Ma3d+e+_sNkFVdYfwsdMrtQ@mail.gmail.com>
	 <1333424865.26079.9.camel@joe2Laptop>
	 <CAPXgP13fDRZtAvV651NPqQ2TgUEtb+MX1EhKhwirAgoiNOg5tQ@mail.gmail.com>
	 <1333463572.26079.31.camel@joe2Laptop>
	 <CAPXgP133MQX2u3H6imOR4FFR4TsHYc=f_yrAJfdd2sG-8bFrmA@mail.gmail.com>
	 <1333469136.26079.33.camel@joe2Laptop>
	 <CAPXgP11MBdqc3BiDLA1q5gW4BZy2q4PoLtD20oRXfKY+C-HOgw@mail.gmail.com>
	 <1333469800.26079.35.camel@joe2Laptop>
	 <CAPXgP13--R6M3FAJ8QCB50eVTo7M9A30OW3rwwV3gv1QEtpBaQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 18:20 +0200, Kay Sievers wrote:
> On Tue, Apr 3, 2012 at 18:16, Joe Perches <joe@perches.com> wrote:
> > Conversations happen all over the place and making
> > separate discussions isn't that valuable nor are
> > they really controllable.
> 
> Sure, but this is not a conversation in that sense, you reply to a
> patch that something is not correct, but what's not correct is not a
> subject of the patch. And that I need to correct.
> 
> > Just write the change log to simply state "add KERN_CONT"
> > without mentioning your unpublished stuff.
> 
> The changelog says:
> 
> "A prototype for kmsg records instead of a byte-stream buffer revealed
> a couple of missing printk(KERN_CONT ...) uses. Subsequent calls produce
> one record per printk() call, while all should have ended up in a single
> record."
> 
> What else do you need?

You need less.

This has nothing to do with the current printk subsystem,
it has only to do with using KERN_CONT.

Maybe:

trivial: add some KERN_CONT markers to continuation lines

or something like:

commit 66d0ae4d6ffa45b8e6d8bdbf85f8f1b285c8152d
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Sun Dec 6 16:16:24 2009 +0100

    PM / Hibernate: Swap, use KERN_CONT
    
    Use KERN_CONT in save_image() for printks, so that anybody won't
    try to add a loglevel.
    
    Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>



