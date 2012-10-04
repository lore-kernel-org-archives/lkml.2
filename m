Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2JDCzB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 22:55:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56131 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab2JDCy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 22:54:59 -0400
Date: Wed, 3 Oct 2012 19:54:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-usb@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 0/2] USB webcam gadget driver fix for linux-next
Message-ID: <20121004025455.GA2214@kroah.com>
References: <506B554A.70102@xenotime.net>
 <1349310762-14209-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349310762-14209-1-git-send-email-laurent.pinchart@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 02:32:40AM +0200, Laurent Pinchart wrote:
> Hi,
> 
> The first patch in this series should fix the UVC gadget compilation errors in
> linux-next. The second patch should make sure I'll be notified next time a
> patch tries to break it :-)
> 
> Both patches are based on Linus' tree.

Thanks, I'll queue these up soon.

greg k-h
