Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab0CUXuV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 19:50:21 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:56203 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324Ab0CUXuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 19:50:20 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Mar 2010 19:50:20 EDT
X-AuditID: 12074423-b7c0bae0000030f0-44-4ba6af8efc43
Message-Id: <E1NtUpP-0002kZ-4S@approx.mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15544] black screen upon S3 resume, syslog has "render error" and "page table error"
In-Reply-To: Your message of "Sun, 21 Mar 2010 21:30:53 BST."
             <hTwaxgnIZ2O.A.PPD.5NopLB@chimera>
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Sun, 21 Mar 2010 19:45:07 -0400
From: Sanjoy Mahajan <sanjoy@MIT.EDU>
X-Brightmail-Tracker: AAAAAhNVozETVapS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It hasn't recurred since I filed the bug report (6 days ago), but as far
as I know it is still a problem.

I'm reasonably sure, but not 100%, that it's a regression: I might have
observed it on Debian's 2.6.32 kernel.  If so, it happened much less often.
