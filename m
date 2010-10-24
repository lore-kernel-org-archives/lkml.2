Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0JXLuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 07:50:04 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54832 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932370Ab0JXLuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 07:50:01 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CC41D61.7020303@s5r6.in-berlin.de>
Date: Sun, 24 Oct 2010 13:49:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
References: <Pine.LNX.4.44L0.1010191049440.1786-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1010191049440.1786-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Okay, here's a patch which definitely causes the problem to surface.  
> It contains some extra debugging printouts but you can ignore them.  Or 
> you can edit out the hunks that affect ehci-q.c.
> 
> Ideally, you would test this while forcing the card reader to run at
> full speed, by putting a USB-1.1 hub between the monitor and the card
> reader.  But if you don't have one available, don't worry -- the error
> message should still appear even though it won't lead to an oops.
> 
> And of course, when you run this along with the proposed fix, the error 
> message should go away.  :-)

Thanks, I will try it RSN, hopefully one of the next few days.
-- 
Stefan Richter
-=====-==-=- =-=- ==---
http://arcgraph.de/sr/
