Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab0IBO0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:26:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35512 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751169Ab0IBO0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:26:45 -0400
Date: Thu, 2 Sep 2010 10:26:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <listar@nl.linux.org>
Subject: Re: Resetting USB HC .. During kernel boot
In-Reply-To: <AANLkTi=ZzbTb+uQchDDYfNibDv=LafQYuvRe2TVFpFGO@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1009021022270.1513-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Sep 2010, Prabhu Chawandi wrote:

> Hi All,
> 
>    I want to reset the USB HC  while the booting is happening. I have
> the register details and functionality with me, but not sure which
> part of the code to insert this segment.
> 
> please advice me ...

Why do you want to do this?

Anyway, it depends on what type of host controller you're talking 
about.  UHCI controllers are already reset during boot.  The same is 
true for PCI-based EHCI and OHCI controllers (except on certain PA-RISC 
systems).

I haven't checked the various non-PCI controllers.

Alan Stern

