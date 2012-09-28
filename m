Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031702Ab2I1Tu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:50:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45991 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030260Ab2I1Tuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:50:52 -0400
Date: Fri, 28 Sep 2012 15:50:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Whitcroft <apw@canonical.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Probable false positive in checkpatch
Message-ID: <Pine.LNX.4.44L0.1209281546480.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy:

Here's what I just got from checkpatch:

ERROR: space prohibited after that '-' (ctx:BxW)
#22: FILE: drivers/usb/host/ehci-sched.c:1419:
+                       start += (next - start + period - 1) & (- period);
                                                                ^
This seems unlikely to be a real style violation.  Or if it is, maybe 
it shouldn't be.  After all, "(0 - period)" would be okay.

Alan Stern

