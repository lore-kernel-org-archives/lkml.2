Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1ECROU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:14:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44564 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013Ab1ECROT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:14:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Subject: Re: [RFC][PATCH] PM: Print a warning if firmware is requested when tasks are frozen
Date: Tue, 3 May 2011 19:14:53 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <201105030044.51661.rjw@sisk.pl> <15997.1304437643@localhost> <1304438196.1788.19.camel@Joe-Laptop>
In-Reply-To: <1304438196.1788.19.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031914.53972.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 03, 2011, Joe Perches wrote:
> On Tue, 2011-05-03 at 11:47 -0400, Valdis.Kletnieks@vt.edu wrote:
> > On Tue, 03 May 2011 13:02:08 +0200, "Rafael J. Wysocki" said:
> > > It's useful, but I'd rather do
> > >  		dev_info(device, "firmware: %s will not be loaded\n", name);
> > That works too.  :)
> 
> A higher KERN_<LEVEL> like dev_alert or dev_err might be better.

Hmm, fair enough.  I'll use dev_err() in the final version.

Thanks,
Rafael
