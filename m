Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030595Ab2K3PIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:08:05 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49426 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030581Ab2K3PIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:08:02 -0500
Date: Fri, 30 Nov 2012 07:09:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121130150944.GB2658@kroah.com>
References: <1354287112-18159-1-git-send-email-eli.billauer@gmail.com>
 <1354287112-18159-2-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354287112-18159-2-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 04:51:52PM +0200, Eli Billauer wrote:
> Xillybus is a general-purpose framework for communication between programmable
> logic (FPGA) and a host. It provides a simple connection between hardware FIFOs
> in the FPGA and their respective device files on the host.
> 
> The user interface is device files that are used like pipe files, only there's
> FPGA logic on the other side rather than another process.
> 
> The underlying transport between the host and FPGA is either PCIe or AXI
> (AMBA bus by ARM).
> 
> The Xillybus logic (IP core) is configurable in the number of pipes it presents
> and their nature. The driver autodetects these pipes, making it essentially
> forward-compatible to future configurations. The benefit of having this driver
> enabled in the kernel is that hardware vendors may release a new card, knowing
> that it will work out of the box on any future Linux machine, with the specific
> configuration defined for the FPGA part.
> 
> Documentation: http://xillybus.com/doc/
> 
> This driver has been available for download for over a year, and has been
> actively used on a wide variety of kernels versions and configurations.

You didn't answer my previous comments about the kernel/user interface
here, why not?

And you ignored my other review comments, which is a sure way for me to
want to reject this and not look at any future submissions from you for
at least a month...

greg k-h
