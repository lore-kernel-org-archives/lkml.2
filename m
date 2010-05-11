Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758023Ab0EKOCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:02:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41854 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757998Ab0EKOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:02:00 -0400
Date: Tue, 11 May 2010 10:01:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Du, Alek" <alek.du@intel.com>
cc: Ondrej Zary <linux@rainbow-software.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [PATCH v2] [RFC] ehci: Disable wake on overcurrent
 (WKOC_E) and disconnect (WKDISC_E)
In-Reply-To: <20100511113120.02787f96@dxy2>
Message-ID: <Pine.LNX.4.44L0.1005111000560.1834-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Du, Alek wrote:

> > Based on your suggestion, I completely redid both of my patches.  They 
> > are now combined into a single patch, which is meant to go on top of 
> > the patch you submitted this morning.  It adds the stuff we talked 
> > about, and it cleans up some of the changes you made.
> > 
> > Does it look good to you?
> > 
> > Alan Stern
> > 
> 
> Alan,
> 
> It looks good and works for my hardware. Thanks a lot!
> Will you submit it soon?

Thank you.  Yes, I will.

Alan Stern

