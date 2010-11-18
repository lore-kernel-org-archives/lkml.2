Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab0KRPcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 10:32:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59549 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758984Ab0KRPcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 10:32:07 -0500
Date: Thu, 18 Nov 2010 10:32:06 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: gimli <gimli@dark-green.com>
cc: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] Fix broken EHCI on MacbookAir3,1 and 3,2
In-Reply-To: <ab0700a6dccc811536a199377f38fa26@mognix.dark-green.com>
Message-ID: <Pine.LNX.4.44L0.1011181030180.1801-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, gimli wrote:

> Workaround and fixup for EHCI power managment on MacBookAir3,1(2). The
> breake happened after 2.6.35.

...

> As you can see, not all devices are connected again after inserting
> ehci-hcd.
> In this bug : https://bugzilla.kernel.org/show_bug.cgi?id=21182 you see
> another user with the same problem.
> I'm not sure if only Apple users with Nvidia chipset are affected.

Shouldn't this patch be CC'ed to the people who wrote the link power 
management changes?  Surely they are in the best position to evaluate 
it and offer suggestions for improvements.

Alan Stern

