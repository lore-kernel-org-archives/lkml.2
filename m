Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755854Ab0K3S5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 13:57:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55735 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751117Ab0K3S5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 13:57:41 -0500
Date: Tue, 30 Nov 2010 13:57:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Alexander E. Patrakov" <patrakov@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Nobody cared about IRQs at shutdown
In-Reply-To: <4CF53D94.4090003@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1011301355430.1686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010, Alexander E. Patrakov wrote:

> In fact, I think that there is something bad, not specific to USB, 
> FireWire or SATA. Without systemd, all those subsystems function 
> properly at shutdown. With systemd, it looks like there are many 
> mishandled interrupts (all of USB, FireWire and SATA) at shutdown. What 
> could be this common thing? ACPI?

I don't know -- what is systemd?

Alan Stern

