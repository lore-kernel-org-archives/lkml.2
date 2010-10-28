Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933791Ab0J1Upr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:45:47 -0400
Received: from kroah.org ([198.145.64.141]:48527 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047Ab0J1Upm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:45:42 -0400
Date: Thu, 28 Oct 2010 13:41:02 -0700
From: Greg KH <greg@kroah.com>
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] [USB] UAS: Rename urbs by pipe
Message-ID: <20101028204101.GA22785@kroah.com>
References: <444316.89210.qm@web31808.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <444316.89210.qm@web31808.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 01:05:14PM -0700, Luben Tuikov wrote:
> The reason to do this is to accommodate sending
> different IU types using the existing
> infrastructure.

I'm sorry, but can you explain this a bit more?  I really don't
understand why this change is necessary.

thanks,

greg k-h
