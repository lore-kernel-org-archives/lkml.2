Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab2LAQ6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:58:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36546 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2LAQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:58:50 -0500
Date: Sat, 1 Dec 2012 08:58:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Philip Balister <philip@balister.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Eli Billauer <eli.billauer@gmail.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121201165846.GI3113@kroah.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
 <201211301728.48008.arnd@arndb.de>
 <20121130173644.GA9841@kroah.com>
 <50B97734.3090207@balister.org>
 <20121201165612.GG3113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121201165612.GG3113@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 08:56:12AM -0800, Greg KH wrote:
> So, in the grand tradition of, "The first one there wins", why not base
> it all off of your driver, and how that works, and we can go from there :)

Oops, sorry s/your/Eli's/, my confusion.

greg k-h
