Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1ECP4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:56:39 -0400
Received: from mail.perches.com ([173.55.12.10]:1179 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134Ab1ECP4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:56:38 -0400
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when
 tasks are frozen
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <15997.1304437643@localhost>
References: <201105030044.51661.rjw@sisk.pl> <50363.1304379012@localhost>
	 <201105031302.08910.rjw@sisk.pl>  <15997.1304437643@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 08:56:36 -0700
Message-ID: <1304438196.1788.19.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 11:47 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 03 May 2011 13:02:08 +0200, "Rafael J. Wysocki" said:
> > It's useful, but I'd rather do
> >  		dev_info(device, "firmware: %s will not be loaded\n", name);
> That works too.  :)

A higher KERN_<LEVEL> like dev_alert or dev_err might be better.


