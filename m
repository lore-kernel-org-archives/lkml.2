Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0EUXmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 19:42:54 -0400
Received: from kroah.org ([198.145.64.141]:44034 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920Ab0EUXmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 19:42:52 -0400
Date: Fri, 21 May 2010 16:42:32 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] pcm551.c: use pci_ids.h defines
Message-ID: <20100521234232.GA31672@kroah.com>
References: <0D753D10438DA54287A00B0270842697636F3238A0@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0D753D10438DA54287A00B0270842697636F3238A0@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 06:24:01PM -0500, H Hartley Sweeten wrote:
> Move the DEVICE id to pci_ids.h and then use the VENDOR/DEVICE ids provided
> in pci_ids.h instead of creating local ids.

Did you read the comment at the top of the pci_ids.h file saying not to
do this?  Just use the vendor id that is already in the pci_ids.h file
in the driver, but leave the device id in the driver itself.

thanks,

greg k-h
