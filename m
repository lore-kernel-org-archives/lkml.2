Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724Ab0J1RnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 13:43:21 -0400
Received: from kroah.org ([198.145.64.141]:48839 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760242Ab0J1RnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 13:43:16 -0400
Date: Thu, 28 Oct 2010 10:36:38 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: v2.6.36-rc8..v2.6.36 regression on NULL pointer deference at
 disk_replace_part_tbl+0x32
Message-ID: <20101028173638.GA1770@kroah.com>
References: <AANLkTi=zj-7MfUihKLvsrP0QJng1mQyDcUmyQWxVY2jR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=zj-7MfUihKLvsrP0QJng1mQyDcUmyQWxVY2jR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:25:17AM -0700, Luis R. Rodriguez wrote:
> I've filled out a bug report for a regression when I enable USB tether
> on my Nexus One when hooked up to my laptop. I get a NULL pointer
> dereference. This is a regression between v2.6.36-rc8 and v2.6.36. I
> will bisect when I get a chance.

I don't see any usb-storage changes between those two releases, so
perhaps this is a scsi issue?

bisection would be great to have.

thanks,

greg k-h
