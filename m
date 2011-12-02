Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab1LBQJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:09:33 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:57762 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab1LBQJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:09:32 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=s3E4aK5dlEwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=ZX0tFa1T0JATFuH8vW4A:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Suspend and resume on ASUS Laptops
From: Steven Rostedt <rostedt@goodmis.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <Pine.LNX.4.44L0.1112021039460.1420-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1112021039460.1420-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 11:09:29 -0500
Message-ID: <1322842169.30977.44.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Fri, 2011-12-02 at 10:43 -0500, Alan Stern wrote:

> It's possible that this problem is related to wakeup settings.  Have 
> you tried disabling wakeup for the EHCI controllers?

I'm totally ignorant of the inner workings of suspend to ram and how
devices deal with it. How do I disable wakeup for the EHCI controllers?

Also, does wakeup have anything to do with suspend. As the name
suggests, it sounds like its more of a resume thing. But again, I'm
ignorant when it comes to these matters. I just want to point out that
without the script, the machine never makes it to a suspend state.

> 
> This certainly appears to be some sort of bug in the firmware.  Finding 
> it and working around it isn't likely to be easy.  Unbinding (or 
> unloading) ehci-hcd may indeed be the path of least resistance.

I wounder what windows does. Of course, vendors bend over backwards for
MS, so it may not need to do much, or MS does something completely
different. I do have this still as a dual boot with Windows7. I don't
wipe my boxes clean of windows anymore. If I have to pay the damn MS
tax, I might as well keep what I paid for :-p

-- Steve


