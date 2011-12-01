Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1LAOgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:36:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40634 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1LAOgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:36:51 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Suspend and resume on ASUS Laptops
Date: Thu, 1 Dec 2011 15:38:06 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc3-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1322712689.30977.11.camel@frodo> <201112011248.44449.oneukum@suse.de> <1322749734.30977.16.camel@frodo>
In-Reply-To: <1322749734.30977.16.camel@frodo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112011538.06912.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 1. Dezember 2011, 15:28:54 schrieb Steven Rostedt:
> On Thu, 2011-12-01 at 12:48 +0100, Oliver Neukum wrote:
> 
> > What errors are seen in the kernel log?
> 
> Without the script, I don't see any errors. Is there some debug thing
> you want me to do? There's no error messages but the system just hangs
> on suspend. It never makes it to the suspend state. The only way out of
> it is to press and hold the power button for 10 seconds to force a hard
> reboot.

I see. I thought the system just refuses to enter S3/4. That it hangs was
new to me. Has there been a mail thread about this problem already?
If not, what is the last thing you see if you go to S3 after you booted
with no_console_suspend on the kernel command line?

	Regards
		Oliver
