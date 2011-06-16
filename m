Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1FPPJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:09:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47211 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756126Ab1FPPJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:09:47 -0400
Date: Thu, 16 Jun 2011 11:09:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 4/5] usb:dummy_hcd: Disable single-request fifo in
 dummy hcd
In-Reply-To: <1308231068-24038-5-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1106161107190.2204-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jun 2011, Tatyana Brokhman wrote:

> This is not the actual behavior of the udc, thus it's removed.

I don't understand.  What UDC are you talking about?  This _is_ the 
actual behavior of the net2280 (depending on which endpoint you're 
looking at and how the device is configured).

> This patch is needed for several of UAS test to pass.

Then the tests are broken.  NAK.

Alan Stern

