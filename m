Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab2CMXVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 19:21:32 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:58633 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2CMXVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 19:21:30 -0400
Date: Tue, 13 Mar 2012 16:21:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Leonid Petrov <user1@lpetrov.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB 3.0 card, chipset VIA VL800 + external harddrive @ 3.3.0-rc7
 = no luck
Message-ID: <20120313232126.GA31025@kroah.com>
References: <4F5F7A3F.nail2BJ11Y4JL@lpetrov.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5F7A3F.nail2BJ11Y4JL@lpetrov.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:47:59PM -0400, Leonid Petrov wrote:
> When connected to usb-3.0: 
> --------------------------
> 
> Mar 13 10:37:52 localhost kernel: hub 10-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?

Are you sure you have a USB 3.0 cable?

And this would be best to be asked on the linux-usb@vger.kernel.org
list, try resending it there.

thanks,

greg k-h
