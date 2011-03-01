Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab1CATdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:33:12 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42165 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752651Ab1CATdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:33:10 -0500
Date: Tue, 1 Mar 2011 14:33:07 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Tardy <tardyp@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [linux-pm] [RFC,PATCHv3 0/3] sdhci runtime_pm implementation
In-Reply-To: <cover.1298820825.git.tardyp@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1103011431400.2034-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Pierre Tardy wrote:

> Please find sdhci runtime_pm implementation.
> 
> It uses clock gating fw as a tip to know when our chip is idle.
> It implements wake up from card insertion/removal.
> 
> This is RFC, please dont merge yet. I really would like to have deep review
> from PCI linux-pm guys.
> 
> Opens are: 
> 
> 1/ Not sure if the pci configs in the driver in rpm_suspend/resume flow
>  are not duplicate from what the core is doing.

There may be one or two small errors.

> 2/ Wakeup from D3hot: I cannot find any driver that is implementing it in current upstream,

Other drivers do it, but they use PCI PME# instead of interrupts.

> I'm not sure if I'm doing it the good way. 
> We have the exact same issue for our not yet upstreamable usb-otg driver.
> Not sure if this cannot be implemented generically in core.

Alan Stern

