Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab1LAJdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 04:33:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36946 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1LAJdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 04:33:05 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Suspend and resume on ASUS Laptops
Date: Thu, 1 Dec 2011 10:35:57 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1322712689.30977.11.camel@frodo>
In-Reply-To: <1322712689.30977.11.camel@frodo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011035.57666.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, December 01, 2011, Steven Rostedt wrote:
> For Black Friday I bought myself a ASUS-U56E-RBL8 at Staples for a
> decent price. I installed Linux on it but it would not suspend. It would
> always hang with the hard drive light on, as well as other leds and the
> power light.
> 
> Searching the web, I found this link:
> 
> http://thecodecentral.com/2011/01/18/fix-ubuntu-10-10-suspendhibernate-not-working-bug
> 
> That talks about adding a script found here:
> 
> http://ubuntuforums.org/showpost.php?p=10359462&postcount=47
> 
> I added the script and sure enough, my suspend and even resume now work.

Now, that's interesting, but I would lie if I said I knew what it was
actually doing, so let me add some USB people to the CC list.

> Before using this script, I've tried this on latest Debian testing and
> with the latest Linus kernel (as of last night), and it didn't work. But
> with this script, it works there and also with Debian stable and 3.0.10
> kernel. (I hate gnome3 and lack of gnome2 so I created a separate
> partition to run Debian testing, but I'm back to Debian stable).
> 
> The reason I'm writing you is, can we fix this without needing this
> script?  Is there a modification to pm-suspend, or something that can
> handle these laptops?
> 
> It just seems crazy to have everyday users add this script.

I totally agree, I had no idea it was necessary.

Thanks,
Rafael
