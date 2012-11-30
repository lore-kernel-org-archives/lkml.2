Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933288Ab2K3QfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:35:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954Ab2K3QfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:35:23 -0500
Date: Fri, 30 Nov 2012 08:35:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v2 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121130163519.GC4478@kroah.com>
References: <1354287112-18159-1-git-send-email-eli.billauer@gmail.com>
 <1354287112-18159-2-git-send-email-eli.billauer@gmail.com>
 <20121130150944.GB2658@kroah.com>
 <50B8D069.8070608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B8D069.8070608@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 05:27:37PM +0200, Eli Billauer wrote:
> I made changes in the code as a response to almost all your comments
> to my best understanding.
> 
> I also sent a separate mail responding to a couple of issues, which
> seems not have reached you.

I now see it, sorry for the grumpy pre-coffee response I made earlier.

> But to put it short:
> 
> * The pci_ids: I wasn't sure if I should remove only my own product
> ID or all the vendor IDs, and this is clear now.

Good.

> * As for the documentation, I don't quite understand what I should
> add. There's a rather extensive documentation for download at the
> site. The docs for the host side mostly instruct common UNIX
> programming techniques: The device files are just data pipes to
> FIFOs in the FPGA, behaving like one would expect.

You need to document the user/kernel API that you have now created for
this driver, either in the Documentation directory, or in the very
least, the driver submission changelog entry.  Otherwise we don't know
where to look, nor if those docs are even correct anymore.

> * As for the special class issue: When Xillybus is used, the whole
> system's mission is usually around it (e.g. it's a computer doing
> data acquisition through the Xillybus pipes). So giving it a high
> profile makes sense, I believe. Besides, a dozen of device files are
> not rare. Needless to say, I'm not going to insist on this.

Good, please use misc device, for the reasons I suggested in my other
email.

> Other than that, it's all changes in the code. It's a major change
> there.

I don't understand what these sentances mean.

greg k-h
