Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab1AFAru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:47:50 -0500
Received: from cantor.suse.de ([195.135.220.2]:52901 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340Ab1AFAaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:10 -0500
Date: Wed, 5 Jan 2011 16:30:03 -0800
From: Greg KH <gregkh@suse.de>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linux-usb <linux-usb@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Sleeping function called from invalid context in 2.6.37
 xhci_hcd
Message-ID: <20110106003003.GA3337@suse.de>
References: <4D250B2B.8090901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D250B2B.8090901@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 06:22:03PM -0600, Robert Hancock wrote:
> Just saw this on booting up on the latest Fedora Rawhide kernel
> based on 2.6.37. Looks like we were trying to do a runtime suspend
> on the xHCI USB controller and it disabled MSI-X while interrupts
> were disabled?

Known issue, patches came in too late to make it for .37, hopefully will
show up in .38-rc and then get backported to .37.  They are on the
linux-usb mailing list if you need them now.

Hope this helps,

greg k-h
