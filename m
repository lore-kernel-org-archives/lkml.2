Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030563Ab2K3PGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:06:52 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45415 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758561Ab2K3PGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:06:51 -0500
Date: Fri, 30 Nov 2012 07:08:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 1/2] pci_ids: Added FPGA-related entries
Message-ID: <20121130150832.GA2658@kroah.com>
References: <1354287112-18159-1-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354287112-18159-1-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 04:51:51PM +0200, Eli Billauer wrote:
> These are Vendor IDs to FPGA manufacturers, and are necessary for the Xillybus
> driver. Even though no other driver uses them currently, I believe their
> place is in the general list for future use. The PCIe interface is
> popular among these FPGAs, and Linux is used often.

Again, only add these entries if they are being used in more than one
place.  If, in the future, another driver needs it, then it can be added
to this file, but not now.

thanks,

greg k-h
