Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab1GAVd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:33:26 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37293 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757817Ab1GAVdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:33:22 -0400
X-Sasl-enc: zHE2QvKUeNACuhQHXAy0V15NJc/RIwCZuQUMvM4AFW1/ 1309556001
Date: Fri, 1 Jul 2011 14:24:27 -0700
From: Greg KH <greg@kroah.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-uvc-devel@lists.berlios.de,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] USB: EHCI: Allow users to override 80% max
 periodic bandwidth
Message-ID: <20110701212427.GA11831@kroah.com>
References: <cover.1309520144.git.kirr@mns.spb.ru>
 <69ea2dd940481508f190419c53c780b626460b22.1309520144.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69ea2dd940481508f190419c53c780b626460b22.1309520144.git.kirr@mns.spb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 01, 2011 at 03:47:11PM +0400, Kirill Smelkov wrote:
>  drivers/usb/host/ehci-sysfs.c |  104 +++++++++++++++++++++++++++++++++++++++--

As you are adding new sysfs files, it is required that you also add new
entries in the Documentation/ABI/ directory.

Please do that for these files so that people have an idea of what they
are, and how to use them.

Care to redo this series with that change?

thanks,

greg k-h
