Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1LALra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:47:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab1LALr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:47:29 -0500
From: Oliver Neukum <oneukum@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend and resume on ASUS Laptops
Date: Thu, 1 Dec 2011 12:48:44 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc3-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1322712689.30977.11.camel@frodo> <201112011035.57666.rjw@sisk.pl>
In-Reply-To: <201112011035.57666.rjw@sisk.pl>
Organization: SUSE
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011248.44449.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 1. Dezember 2011, 10:35:57 schrieb Rafael J. Wysocki:
> > Searching the web, I found this link:
> > 
> > http://thecodecentral.com/2011/01/18/fix-ubuntu-10-10-suspendhibernate-not-working-bug
> > 
> > That talks about adding a script found here:
> > 
> > http://ubuntuforums.org/showpost.php?p=10359462&postcount=47
> > 
> > I added the script and sure enough, my suspend and even resume now work.
> 
> Now, that's interesting, but I would lie if I said I knew what it was
> actually doing, so let me add some USB people to the CC list.

What errors are seen in the kernel log?

	Regards
		Oliver
