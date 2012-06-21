Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab2FUQMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:12:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42225 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759452Ab2FUQMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:12:44 -0400
Date: Thu, 21 Jun 2012 12:12:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
In-Reply-To: <CACVXFVM=p3_rqsRF0BWdZ30GW5zgDgy6jbfqNP6xwHJoOQx1Wg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206211210510.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2012, Ming Lei wrote:

> On Thu, Jun 21, 2012 at 9:49 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > We also have not made the rule that a shutdown will complete in a
> > specific amount of time either, so there is no problem if that takes a
> > long time as well.
> 
> OK, I will submit a new patch which just holds device lock.
> 
> Alan, do you have objections on the new one?

No objections.  It should end up being pretty much like one of the 
patches you posted earlier.

Should there be an option for a debug log of each device name just 
before its shutdown routine is called?

Alan Stern

