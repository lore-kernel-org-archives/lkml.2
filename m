Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0IUWkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 18:40:23 -0400
Received: from kroah.org ([198.145.64.141]:51285 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab0IUWkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 18:40:22 -0400
Date: Tue, 21 Sep 2010 15:25:48 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, gregkh@suse.de,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] FW_LOADER: fix kconfig dependency warning on HOTPLUG
Message-ID: <20100921222548.GA21202@kroah.com>
References: <20100918132308.074b6c01.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100918132308.074b6c01.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 01:23:08PM -0700, Randy Dunlap wrote:
> 
> BTW, drivers/base/firmware_class.c should #include <linux/kobject.h>.

Why, it looks like it builds properly now, right?

thanks,

greg k-h
