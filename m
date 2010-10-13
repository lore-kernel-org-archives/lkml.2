Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0JMWm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 18:42:28 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53922 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab0JMWm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 18:42:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB635C1.6040308@s5r6.in-berlin.de>
Date: Thu, 14 Oct 2010 00:42:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
References: <Pine.LNX.4.44L0.1010131011160.2311-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1010131011160.2311-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> Stefan, is it possible for you to tell whether this really does work?

That will be hard.  So far I was unable to reproduce the oops; still running
unmodified 2.6.36-rc7.
-- 
Stefan Richter
-=====-==-=- =-=- -===-
http://arcgraph.de/sr/
