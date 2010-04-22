Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0DVQYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 12:24:43 -0400
Received: from kroah.org ([198.145.64.141]:33313 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab0DVQYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 12:24:40 -0400
Date: Thu, 22 Apr 2010 09:24:20 -0700
From: Greg KH <greg@kroah.com>
To: Dan Carpenter <error27@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alessio Igor Bogani <abogani@texware.it>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] usb: testing the wrong variable in fs_create_by_name()
Message-ID: <20100422162420.GC30730@kroah.com>
References: <20100422100052.GT29647@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100422100052.GT29647@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 12:00:52PM +0200, Dan Carpenter wrote:
> There is a typo here.  We should be testing "*dentry" which was just
> assigned instead of "dentry".  This could result in dereferencing an
> ERR_PTR inside either usbfs_mkdir() or usbfs_create().
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Nice catch, thanks.  I'll go queue this up.

greg k-h
