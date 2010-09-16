Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0IPTwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 15:52:39 -0400
Received: from kroah.org ([198.145.64.141]:39112 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309Ab0IPTwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 15:52:03 -0400
Date: Thu, 16 Sep 2010 12:33:58 -0700
From: Greg KH <greg@kroah.com>
To: Al Cho <acho@novell.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw
Subject: Re: [PATCH] staging/keucr: fix keucr lost disconnect
Message-ID: <20100916193358.GF10397@kroah.com>
References: <1284609108-11103-1-git-send-email-acho@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284609108-11103-1-git-send-email-acho@novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 11:51:48AM +0800, Al Cho wrote:
> keucr lost the disconnect,
> so keucr crash when plug-in and then plug-out SD-card quickly.
> 
> unmark the part of usb disconnect

Nice fix, so the driver works properly now?

thanks,

greg k-h
