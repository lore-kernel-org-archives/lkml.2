Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab1LAPUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:20:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:47485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab1LAPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:20:04 -0500
X-Authority-Analysis: v=2.0 cv=dOUkaZlb c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=s3E4aK5dlEwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=Jys0o8JDEI-FhwHUjcEA:9 a=fKLjgkNCVYHUkDEt49QA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Suspend and resume on ASUS Laptops
From: Steven Rostedt <rostedt@goodmis.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
In-Reply-To: <201112011538.06912.oneukum@suse.de>
References: <1322712689.30977.11.camel@frodo>
	 <201112011248.44449.oneukum@suse.de> <1322749734.30977.16.camel@frodo>
	 <201112011538.06912.oneukum@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 10:20:02 -0500
Message-ID: <1322752802.30977.28.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 15:38 +0100, Oliver Neukum wrote:
> Am Donnerstag, 1. Dezember 2011, 15:28:54 schrieb Steven Rostedt:
> > On Thu, 2011-12-01 at 12:48 +0100, Oliver Neukum wrote:
> > 
> > > What errors are seen in the kernel log?
> > 
> > Without the script, I don't see any errors. Is there some debug thing
> > you want me to do? There's no error messages but the system just hangs
> > on suspend. It never makes it to the suspend state. The only way out of
> > it is to press and hold the power button for 10 seconds to force a hard
> > reboot.
> 
> I see. I thought the system just refuses to enter S3/4. That it hangs was
> new to me. Has there been a mail thread about this problem already?

No idea, but I did reference a website that posted this fix. I'm not
sure how the fix came about, or what discussions were done. The fix
seems to have been made by Ubuntu, which means its just another thing
they looked at without sending upstream :-p

> If not, what is the last thing you see if you go to S3 after you booted
> with no_console_suspend on the kernel command line?

Hmm, no_console_suspend on the kernel command line seems to do nothing.
It still hangs hard without the script, and suspend works fine with the
script.

I noticed that /sys/module/printk/parameters/console_suspend doesn't
exist. Am I missing a kernel config option?

-- Steve


