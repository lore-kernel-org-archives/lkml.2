Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab2DPIag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:30:36 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:54832 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2DPIaf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:30:35 -0400
X-Greylist: delayed 454 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Apr 2012 04:30:35 EDT
Message-Id: <4F8BF2FD020000A1000097D2@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 16 Apr 2012 10:22:53 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: When do files in /proc change their times?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have a simple question: When do files in /proc show changed modification times?
Specifically: When is "/proc/sys/kernel/random/boot_id" expected to change ist time?

I found out that usually the "file" doesn't change ist modification times, so I expected the modification times to change when the content changes. Obviously a wrong assumption: No reboot, but the file date changed.

According to syslog there was nothing special, but I did install some software packages (SLES11 SP1 (2.6.32.54-0.3-xen), no kernel) some seconds before that.

Maybe some kind soul could answer and CC: me as I'm not subscribed to the kernel list.

Regards,
Ulrich Windl


