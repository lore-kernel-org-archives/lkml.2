Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab0KFFOu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 01:14:50 -0400
Received: from kroah.org ([198.145.64.141]:47310 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840Ab0KFFOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 01:14:47 -0400
Date: Fri, 5 Nov 2010 22:14:47 -0700
From: Greg KH <greg@kroah.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] [USB] UAS: Achitecture; TMF; more
Message-ID: <20101106051447.GA2327@kroah.com>
References: <130.74979.qm@web31805.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <130.74979.qm@web31805.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 09:46:49PM -0700, Luben Tuikov wrote:
> This patch changes 86% of the driver. More is to come, but this is
> a self-contained patch so it can be applied.

No it can not at all, sorry.

Remember, patches do one single thing at a time.  This patch is
equivalant to deleting the file and replacing it with a totally
different driver, which is unacceptable.

Please break all of these changes up into individual patches and
resubmit them.  That's the only way we can take them.  I also suggest
you go re-read Documentation/development_process/ as well.

thanks,

greg k-h
