Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758917Ab0CPVYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:24:31 -0400
Received: from kroah.org ([198.145.64.141]:49032 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0CPVYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:24:23 -0400
Date: Tue, 16 Mar 2010 14:23:50 -0700
From: Greg KH <greg@kroah.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] usb-serial: Use tty_port version of console
	instead of the usb_serial_port version
Message-ID: <20100316212350.GC31739@kroah.com>
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com> <1268773546-12457-2-git-send-email-jason.wessel@windriver.com> <1268773546-12457-3-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268773546-12457-3-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 04:05:43PM -0500, Jason Wessel wrote:
> Replace all instances of using the console variable in struct
> usb_serial_port with the struct tty_port version.

I've also already applied this one, right?

thanks,

greg k-h
