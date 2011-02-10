Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1BJS4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:56:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41138 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751334Ab1BJS4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:56:32 -0500
Date: Thu, 10 Feb 2011 13:56:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ian Campbell <ijc@hellion.org.uk>
cc: Brendan Cully <brendan@cs.ubc.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
Subject: Re: [Xen-devel] Re: [linux-pm] [PATCH 0/2] Fix hangup after creating
 checkpoint on Xen.
In-Reply-To: <1297355688.21980.488.camel@zakaz.uk.xensource.com>
Message-ID: <Pine.LNX.4.44L0.1102101353520.2029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Ian Campbell wrote:

> The documentation of the individual events in pm.h is good. Is there a
> reference for the sequence of events for the different types of
> suspend/hibernate/etc?

There's Documentation/power/devices.txt.

Alan Stern

