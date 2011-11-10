Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab1KJT6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:58:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39487 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751938Ab1KJT6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:58:51 -0500
Date: Thu, 10 Nov 2011 14:58:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Thomas Meyer <thomas@m3y3r.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: OHCI/EHCI-XLS: Use resource_size v2
In-Reply-To: <1320948556.20155.23.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.1111101457140.2338-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Thomas Meyer wrote:

> Use resource_size function on resource object
> instead of explicit computation.
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/resource_size.cocci.

Are you having some trouble getting your scripts to email these patches 
correctly?  You have sent them out four or five times now, and they 
have been messed up each time.

Alan Stern

