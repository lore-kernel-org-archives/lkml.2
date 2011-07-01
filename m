Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1GAPlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:41:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37624 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751363Ab1GAPlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:41:07 -0400
Date: Fri, 1 Jul 2011 11:41:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kirill Smelkov <kirr@mns.spb.ru>
cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into ehci-sysfs.c
In-Reply-To: <20110701114927.GA15802@tugrik.mns.mnsspb.ru>
Message-ID: <Pine.LNX.4.44L0.1107011139560.1988-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jul 2011, Kirill Smelkov wrote:

> > > The checking is not a priority for me here, so if you think it's better not
> > > to check or do it under #ifdef - let's do it. Though of course we all
> > > have our preferences :)
> > 
> > Yes, it's just a matter of taste.  I prefer to add as little code as 
> > possible for a feature that won't be used much.
> 
> 
> Look: we have 3 choices: to check or not to check, and if we are
> checking whether it is under #ifdef DEBUG. Not checking at all makes the
> code inconsistent with the check in periodic_usecs(). Then, if we are
> checking, putting it under #ifdef DEBUG goes against minimum complexity /
> "to add as little code as possible ...". It looks the good balance is to
> leave the checking as is module you above remark.
> 
> And with the above-mentioned correction and comments inspired by Sarah's
> concern I'm resending the whole series as v3. Can we do it this way,
> please?

Okay, you can add my Acked-by to the 2/2 patch.

Alan Stern

