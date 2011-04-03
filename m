Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1DCQC4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 12:02:56 -0400
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:39266 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab1DCQCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 12:02:53 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D989A8A.3050700@cam.ac.uk>
Date: Sun, 03 Apr 2011 17:04:26 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Possible to software trigger an interrupt?
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Having produced a proof of concept for using gpio chips
to handle the triggers in IIO I am looking at converting
over our sysfs trigger.  This trigger is used to initialize
capture on devices in a similar way to dataready interrupts.
The key point is we want to handle this in the same way within
drivers as the hardware event triggers. 

It is a very useful tool.  So the upshot is, what is the best
way to handle causing an interrupt to occur from userspace?

Any pointers on how to do this would be most welcome.

Thanks,

Jonathan
