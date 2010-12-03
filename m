Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab0LCPUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:20:23 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:58140 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750837Ab0LCPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:20:22 -0500
Date: Fri, 3 Dec 2010 10:20:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Kevin Smith <thirdwiggin@gmail.com>
Subject: Re: [Bug #23012] ftdi_sio /dev/ttyUSB error:  "Resource Temporarily
 Unavailable"
In-Reply-To: <gUkHV_Vc3aE.A.lVH.0yC-MB@chimera>
Message-ID: <Pine.LNX.4.44L0.1012031019290.1682-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.36.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23012
> Subject		: ftdi_sio /dev/ttyUSB error:  "Resource Temporarily Unavailable"
> Submitter	: Kevin Smith <thirdwiggin@gmail.com>
> Date		: 2010-11-16 06:25 (17 days old)
> Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=38372

This has been fixed by commit bf03184a31a3286fc0ab30f838ddee8ba9f9b7b 
(USB: fix autosuspend bug in usb-serial).

Alan Stern


