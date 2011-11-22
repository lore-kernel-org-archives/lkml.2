Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab1KVQ0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:26:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36639 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752522Ab1KVQ0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:26:04 -0500
Date: Tue, 22 Nov 2011 11:26:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aman Deep <amandeep3986@gmail.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] xHCI: Adding #define values used for hub descriptor
In-Reply-To: <1321970616-1298-1-git-send-email-amandeep3986@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1111221125040.2466-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011, Aman Deep wrote:

> xhci-hub used some numerical values for initialisation of root hub
> descriptors. #define values are addded in usb 2.0 hub specification
> file and these values are used for root hub characteristics
> initialisation.
> 
> Also use some #defines in places where magic numbers are being used.

This is good.  Can you also add similar changes to hub_configure() in 
drivers/usb/core/hub.c?

Alan Stern

