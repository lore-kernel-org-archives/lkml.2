Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2FMBFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 21:05:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49574 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2FMBFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 21:05:45 -0400
Date: Tue, 12 Jun 2012 18:05:41 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, linux-usb@vger.kernel.org
Subject: Re: [PATCH 12/13] Introduce single user mode
Message-ID: <20120613010541.GE6765@kroah.com>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
 <1339057243-10029-13-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339057243-10029-13-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 10:20:42AM +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> Most USB devices can only used in a single usage mode. This patch prevents a
> reopening on an already opened device.

That's not true at all, most devices work just fine with multiple opens,
it just depends on the type of device you have.

thanks,

greg k-h
