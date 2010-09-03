Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999Ab0ICOFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 10:05:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44827 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752829Ab0ICOFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 10:05:17 -0400
Date: Fri, 3 Sep 2010 10:05:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Prabhu Chawandi <prabhu.chavandi@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <listar@nl.linux.org>, <kernelnewbies@nl.linux.org>
Subject: Re: Resetting USB HC .. During kernel boot
In-Reply-To: <AANLkTin5U3xY2ZFSZ9RsK7mADy0L8XiGWrsFHhQ=-WEx@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1009031004180.1548-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010, Prabhu Chawandi wrote:

> Hi Alan,
> 
>   I am working on a board, where USB controller is on chip. and this
> has both UHC and EHC.  I have to reset these during the boot up.
> Bootloader does not reset it before handing over control to kernel, I
> am facing crash. So I am planning to reset here in kernel.
> 
> Can you help to locate the file, where this part of the code can be inserted.

No.  All I can tell you is that it will be somewhere in the 
platform-specific code for your board, i.e., somewhere under arch/.

Alan Stern

