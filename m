Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0DWSEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 14:04:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51565 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758468Ab0DWSES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 14:04:18 -0400
Date: Fri, 23 Apr 2010 14:04:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core internal
 headers
In-Reply-To: <4BD1DE30.5030405@VirtualLogix.com>
Message-ID: <Pine.LNX.4.44L0.1004231402180.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Eric Lescouet wrote:

> Well, most of the files include hcd.h (which includes hub.h),
> only ~4 of them directly use hub.h.

Oh.  Okay, that makes life easier.  Probably some of the files which 
include hub.h directly also include hcd.h.

> So what's your vote? rename hub.h into ch11.h?

Yeah, go ahead.  I like the idea of the kernel containing information 
about Chapter 11.  (Although I haven't heard of anyone yet going 
bankrupt as a result of using Linux...)

Alan Stern

