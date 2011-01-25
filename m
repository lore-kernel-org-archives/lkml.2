Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab1AYB7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:59:37 -0500
Received: from kroah.org ([198.145.64.141]:56994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab1AYB7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:59:36 -0500
Date: Tue, 25 Jan 2011 10:00:31 +0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 6/6] driver: Google Memory Console
Message-ID: <20110125020031.GA3389@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002505.12637.84140.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125002505.12637.84140.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 04:25:05PM -0800, Mike Waychison wrote:
> This patch introduces the 'memconsole' driver.
> 
> Our firmware gives us access to an in-memory log of the firmware's
> output.   This gives us visibility in a data-center of headless machines
> as to what the firmware is doing.
> 
> The memory console is found by the driver by finding a header block in
> the EBDA.  The buffer is then copied out, and is currently prepended
> to the kernel's dmesg ring-buffer.

Why does this have to be the first thing in the dmesg buffer?
What's wrong with it showing up whenever this driver is loaded like all
other drivers?

thanks,

greg k-h
