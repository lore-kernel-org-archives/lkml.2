Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab1A1P1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:27:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50495 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752063Ab1A1P1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:27:07 -0500
Date: Fri, 28 Jan 2011 10:27:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yin Kangkai <kangkai.yin@intel.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <stable@kernel.org>
Subject: Re: [PATCH v2] USB: EHCI: fix scheduling while atomic during suspend
In-Reply-To: <1296187475-8161-1-git-send-email-kangkai.yin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1101281026010.2089-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011, Yin Kangkai wrote:

> There is a msleep with spin lock held during ehci pci suspend, which will
> cause kernel BUG: scheduling while atomic. Fix that.

> v2:
>  - move spin_lock_irqsave to a smaller scope.
> 
> CC: Alan Stern <stern@rowland.harvard.edu>
> CC: David Brownell <dbrownell@users.sourceforge.net>
> CC: Greg Kroah-Hartman <gregkh@suse.de>
> CC: stable@kernel.org
> Signed-off-by: Yin Kangkai <kangkai.yin@intel.com>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

