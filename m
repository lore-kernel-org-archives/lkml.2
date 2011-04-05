Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1DEONy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:13:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49204 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751169Ab1DEONx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:13:53 -0400
Date: Tue, 5 Apr 2011 10:13:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oncaphillis <oncaphillis@snafu.de>
cc: Xiaofan Chen <xiaofanc@gmail.com>, <libusb-devel@lists.sourceforge.net>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Libusb-devel] Kernel bug message and missing data on
 libusb_interrupt_transfer
In-Reply-To: <4D9AE10E.3080501@snafu.de>
Message-ID: <Pine.LNX.4.44L0.1104051013100.1972-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Apr 2011, Oncaphillis wrote:

> Now I get
> 
> <snip>
> ------------[ cut here ]------------
> kernel BUG at mm/slub.c:2808!
> invalid opcode: 0000 [#2] SMP

Can you duplicate this using either a 2.6.37 or 2.6.38 kernel?

Alan Stern

