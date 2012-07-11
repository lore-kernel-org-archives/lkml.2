Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab2GKPPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 11:15:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52172 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932758Ab2GKPPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 11:15:41 -0400
Date: Wed, 11 Jul 2012 11:15:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-usb@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <4FFD929F.9060500@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1207111114460.1559-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2012, Udo van den Heuvel wrote:

> New occurrence:
> 
> Jul 11 16:45:26 box3 kernel: irq 18: nobody cared (try booting with the
> "irqpoll" option)
> Jul 11 16:45:26 box3 kernel: Pid: 1465, comm: irq/18-ohci_hcd Not
> tainted 3.4.4 #3

> Any clues and/or updates?

Didn't you see the message I posted on Monday?

	http://marc.info/?l=linux-usb&m=134186054713868&w=2

Alan Stern

