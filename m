Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934389Ab1FWSyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:54:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35233 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932313Ab1FWSyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:54:01 -0400
Date: Thu, 23 Jun 2011 14:54:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andi Kleen <andi@firstfloor.org>
cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>, <ak@linux.intel.com>,
        <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
Subject: Re: [PATCH] [115/275] OHCI: work around for nVidia shutdown problem
In-Reply-To: <20110331060711.GL21838@one.firstfloor.org>
Message-ID: <Pine.LNX.4.44L0.1106231451481.2033-100000@iolanthe.rowland.org>
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

I think it has been long enough, and no more complaints have shown up.
That fix is in the mainstream kernel as commit
2b7aaf503d56216b847c8265421d2a7d9b42df3e.  It should be safe to add the
two changes in your longterm stable tree.

Alan Stern

