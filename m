Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab0LCVbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 16:31:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab0LCVbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:31:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #23012] ftdi_sio /dev/ttyUSB error:  "Resource Temporarily Unavailable"
Date: Fri, 3 Dec 2010 22:30:32 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Kevin Smith <thirdwiggin@gmail.com>
References: <Pine.LNX.4.44L0.1012031019290.1682-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1012031019290.1682-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012032230.32356.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 03, 2010, Alan Stern wrote:
> On Fri, 3 Dec 2010, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.36.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=23012
> > Subject		: ftdi_sio /dev/ttyUSB error:  "Resource Temporarily Unavailable"
> > Submitter	: Kevin Smith <thirdwiggin@gmail.com>
> > Date		: 2010-11-16 06:25 (17 days old)
> > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=38372
> 
> This has been fixed by commit bf03184a31a3286fc0ab30f838ddee8ba9f9b7b 
> (USB: fix autosuspend bug in usb-serial).

Thanks, closing.

Rafael
