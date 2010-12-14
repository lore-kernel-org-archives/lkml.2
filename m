Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab0LNVjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:39:51 -0500
Received: from smtp-rs1-vallila2.fe.helsinki.fi ([128.214.173.75]:36524 "EHLO
	smtp-rs1.it.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab0LNVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:39:50 -0500
Date: Tue, 14 Dec 2010 23:39:32 +0200 (EET)
From: Jouko Orava <jouko.orava@helsinki.fi>
Reply-To: Jouko Orava <jouko.orava@iki.fi>
To: Shaun Ruffell <sruffell@digium.com>
cc: Jouko Orava <jouko.orava@helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Custom kernel logging using an USB microcontroller?
In-Reply-To: <4D07806C.3070009@digium.com>
Message-ID: <alpine.LRH.2.00.1012142315000.7914@ruuvi.it.helsinki.fi>
References: <alpine.LRH.2.00.1012130108200.12183@ruuvi.it.helsinki.fi> <4D07806C.3070009@digium.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2010 05:31 PM, Jouko Orava wrote:
> > Would any of you happen to have written a kernel module for
> > custom kernel logging to a USB microcontroller?

On Tue, 14 Dec 2010, Shaun Ruffell wrote:
> Will netconsole (see Documentation/networking/netconsole.txt) work for
> you?  Presumably you have a network adapter or can add a USB network
> adapter.

Sure, thanks for the pointer.

However, I think I can adapt the skeleton USB driver for my needs.
After all, I only need an in-kernel custom_printk() which I could sprinkle
in the kernel codepaths I'm interested in.

Thanks,
	Jouko
