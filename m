Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab2FFQz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:55:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51323 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755913Ab2FFQzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:55:55 -0400
Date: Wed, 6 Jun 2012 12:55:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: linux-kernel@vger.kernel.org, <gregkh@linuxfoundation.org>,
        <oneukum@suse.de>, <alan@lxorguk.ukuu.org.uk>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] fix usb skeleton driver
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
Message-ID: <Pine.LNX.4.44L0.1206061252000.1788-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012 stefani@seibold.net wrote:

> From: Stefani Seibold <stefani@seibold.net>
> 
> This is a fix for the USB skeleton driver to bring it in shape.
> 
> - The usb_interface structure pointer will be no longer stored 
> - Every access to the USB will be handled trought the usb_interface pointer

Those two changes sound contradictory.

> - Add a new bool 'connected' for signaling a disconnect (== false)
> - Handle a non blocking read without blocking
> - Code cleanup
> - Synchronize disconnect() handler with open() and release(), to fix races
> - Introduced fsync
> - Single user mode
> - Eliminated dead code
> - Save some bytes in the dev structure

How about simplifying the code so that it can be read by somebody who's 
not already an expert?

Alan Stern

