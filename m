Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1BIWLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:11:10 -0500
Received: from void.printf.net ([89.145.121.20]:38198 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1BIWLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:11:09 -0500
Date: Wed, 9 Feb 2011 22:11:07 +0000
From: Chris Ball <cjb@laptop.org>
To: Amirali Shambayati <amirali.shambayati@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ubuntu boot problem after compiling new kernel
Message-ID: <20110209221107.GA4561@void.printf.net>
References: <AANLkTin20CuVOpK25TTCD=195Fqktre2zWCbwC+2SPHX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin20CuVOpK25TTCD=195Fqktre2zWCbwC+2SPHX@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 10, 2011 at 01:30:56AM +0330, Amirali Shambayati wrote:
> Hello all,
> I compiled a new kernel according to
> http://www.howtoforge.com/kernel_compilation_ubuntu instructions. The
> kernel version is 2.6.18.1 and I did it in ubuntu 10.04 installed on
> Virtualbox. But by choosing this kernel at grub, it gives this error:
> 
> libudev: udev_monitor_new_from_netlink: error getting socket: Invalid argument

2.6.18.1 is more than 4 years old.  Ubuntu 10.04 requires 2.6.32 or higher.
You need to use a newer kernel.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
