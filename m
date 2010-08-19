Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab0HSOjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 10:39:53 -0400
Received: from kroah.org ([198.145.64.141]:49751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753637Ab0HSOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 10:39:51 -0400
Date: Thu, 19 Aug 2010 07:34:52 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>,
        Linux USB <linux-usb@vger.kernel.org>,
        Adrian Drzewiecki <adriand@vmware.com>
Subject: Re: RIP: 0010:[<ffffffff81495d87>] [<ffffffff81495d87>]
	_raw_spin_lock_irq+0x1b/0x2b
Message-ID: <20100819143452.GE13063@kroah.com>
References: <AANLkTi=m8GPqj2g9GXK+Kmh2dpeCba7vfyGaax3AWZjz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=m8GPqj2g9GXK+Kmh2dpeCba7vfyGaax3AWZjz@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 19, 2010 at 09:16:26AM +0800, Jeff Chua wrote:
> Not sure if this is a vmware bug or kernel, so I'm posting it here.
> Tried to upgrade my iPhone4 iOS to 4.0.2 running a VMware guest with
> Linux-2.6.35+ and Linux-2.6.36-rc1, and both has the same problem.

Known issue, the fix is now in Linus's tree.

thanks,

greg k-h
