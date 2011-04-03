Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab1DCQck (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:32:40 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:57437 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1DCQcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:32:39 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D98A185.1080704@cam.ac.uk>
Date: Sun, 03 Apr 2011 17:34:13 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Possible to software trigger an interrupt?
References: <4D989A8A.3050700@cam.ac.uk>
In-Reply-To: <4D989A8A.3050700@cam.ac.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/11 17:04, Jonathan Cameron wrote:
> Hi,
> 
> Having produced a proof of concept for using gpio chips
> to handle the triggers in IIO I am looking at converting
> over our sysfs trigger.  This trigger is used to initialize
> capture on devices in a similar way to dataready interrupts.
> The key point is we want to handle this in the same way within
> drivers as the hardware event triggers. 
> 
> It is a very useful tool.  So the upshot is, what is the best
> way to handle causing an interrupt to occur from userspace?
> 
> Any pointers on how to do this would be most welcome.

For what it is worth, the incredibly dumb approach of just
calling handle_nested_irq seems to 'work'.   I dread to think
what that might be quietly breaking though...

My understanding of some of this code is still rather limited
I'm afraid!

Jonathan
