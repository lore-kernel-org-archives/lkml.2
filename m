Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab1CaNzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 09:55:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41013 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757796Ab1CaNzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 09:55:41 -0400
Date: Thu, 31 Mar 2011 09:55:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, <ak@linux.intel.com>,
        <david-b@pacbell.net>, <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
        <tim.bird@am.sony.com>
Subject: Re: [PATCH] [115/275] OHCI: work around for nVidia shutdown problem
In-Reply-To: <20110331060711.GL21838@one.firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.1103310948010.2025-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, Andi Kleen wrote:

> On Thu, Mar 31, 2011 at 07:54:31AM +0200, Pali Rohár wrote:
> > Hello,
> > 
> > please see comment 33 in LP bug tracker:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/42149
> 
> Alan? Should I include http://marc.info/?l=linux-usb&m=130142049527638&w=2
> too or drop this patch?

For now I think it should be dropped.  There is a fix for the problem
in that comment, but so far only one person has tested it (in fact,
only one person has reported having the problem).  For details, see the
thread starting here:

	http://marc.info/?l=linux-kernel&m=130132879827993&w=2

When the fix is approved and goes into the other stable kernels, then 
you can merge both patches.

Alan Stern

