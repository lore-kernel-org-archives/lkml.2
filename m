Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab1JLOXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:23:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1JLOXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:23:35 -0400
Date: Wed, 12 Oct 2011 08:17:24 -0600
From: Greg KH <gregkh@suse.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111012141724.GA17414@suse.de>
References: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+O4pCKMiLK3Z94j1NjVA3Zu-32X=tC-6eZnwGZCQXUTbhiEwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 12, 2011 at 02:36:59PM +0200, Markus Rechberger wrote:
> We have 2 products which can perform better with increased Bulk transfers

I don't believe you :)

As stated before, this patch is not acceptable.  Please work to figure
out the real reason for your device problems here, this is not the
correct solution at all.

sorry,

greg k-h
