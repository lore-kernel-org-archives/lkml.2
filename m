Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273Ab0DILdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:33:50 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:63027 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab0DILdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:33:47 -0400
X-AuditID: 12074424-b7b9dae000002832-6e-4bbf109ab752
Message-Id: <E1O0CSx-0006Rn-8j@approx.mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15544] black screen upon S3 resume, syslog has "render error" and "page table error"
In-Reply-To: Your message of "Fri, 09 Apr 2010 01:04:35 +0200."
             <onZ81XwyNTD.A.5OC.UEmvLB@chimera>
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Fri, 09 Apr 2010 07:33:39 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
X-Brightmail-Tracker: AAAAAxOdmx0TnZ1yE52kdA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I haven't seen the bug recur since March 23rd, although I'm running the
same kernel (vanilla 2.6.33).  The X server has been updated slightly
to Debian's xserver-xorg-core 1.7.6.
