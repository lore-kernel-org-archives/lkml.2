Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1GARTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 13:19:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52558 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753516Ab1GARTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 13:19:24 -0400
Date: Fri, 1 Jul 2011 13:19:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?ISO-8859-1?Q?=C9ric_Piel?= <e.a.b.piel@tudelft.nl>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc5+ : khubd blocked
In-Reply-To: <yv9k2yk6fasx2kndcq3elqvq.1309537225091@email.android.com>
Message-ID: <Pine.LNX.4.44L0.1107011317250.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011, [ISO-8859-1] Éric Piel wrote:

> Sorry, but from a quick look, it seems to not fix the bug.
> 
> I'll try further on Monday.

Do you get a similar message from the task watchdog?  The patch should 
have caused usb_set_interface() to return early, without trying to 
acquire the mutex that caused the problem before.

Alan Stern


