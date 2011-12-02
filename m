Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1LBRlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:41:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:32923 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab1LBRli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:41:38 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=s3E4aK5dlEwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=0GTpkGpnSIJV1FH7Y0EA:9 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
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
In-Reply-To: <Pine.LNX.4.44L0.1112021114540.1420-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1112021114540.1420-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 12:41:34 -0500
Message-ID: <1322847694.30977.45.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 11:23 -0500, Alan Stern wrote:

> Take a look at the two files
> 
> 	/sys/bus/pci/devices/0000:00:1[ad].0/power/wakeup
> 
> If they contain the word "enabled", write "disabled" to them.  See 
> Documentation/ABI/testing/sysfs-devices-power.

The files do exist, but they are already set to "disabled".


> >  Of course, vendors bend over backwards for
> > MS, so it may not need to do much, or MS does something completely
> > different. I do have this still as a dual boot with Windows7. I don't
> > wipe my boxes clean of windows anymore. If I have to pay the damn MS
> > tax, I might as well keep what I paid for :-p
> 
> I know; me too.  Even though I almost never use it.

But it is nice to have to double check if things are screwed up on it
too.

-- Steve


