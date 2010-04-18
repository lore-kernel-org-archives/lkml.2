Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab0DRCTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 22:19:40 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:59476 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756574Ab0DRCTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 22:19:39 -0400
X-AuditID: 1209190e-b7b82ae000005260-64-4bca6c39f74f
Message-Id: <E1O3K6c-0000ly-GA@approx.mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15544] black screen upon S3 resume, syslog has "render error" and "page table error"
In-Reply-To: Your message of "Fri, 09 Apr 2010 21:52:21 +0200."
             <201004092152.21306.rjw@sisk.pl>
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sat, 17 Apr 2010 22:19:30 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
X-Brightmail-Tracker: AAAAAhO1V3QTtWCz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just 10 minutes ago I had a similar or maybe an identical problem: When
the laptop woke up from (S3) sleep, the screen was very dim and almost
black, although everything else seemed normal -- e.g. I could use my Fn
key bindings in twm, switch windows, type, switch to a console, etc..

The screen was so dim that I could barely see the outlines of the emacs
and xpdf windows.  Restarting xdm (and therefore the X server) didn't
restore the brightness.  But it probably is not a hardware problem,
because rebooting the laptop restored the brightness to normal.

-Sanjoy

`Until lions have their historians, tales of the hunt shall always
 glorify the hunters.'  --African Proverb
