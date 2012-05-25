Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932553Ab2EYLpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 07:45:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932125Ab2EYLpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 07:45:20 -0400
Date: Fri, 25 May 2012 07:45:12 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Lan Tianyu <tianyu.lan@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB device PM oddity in 3.5
Message-ID: <20120525114512.GB23824@zod.bos.redhat.com>
References: <20120524203655.GK1143@zod.bos.redhat.com>
 <Pine.LNX.4.44L0.1205241646080.1186-100000@iolanthe.rowland.org>
 <20120525113936.GA23824@zod.bos.redhat.com>
 <20120525114152.GA10193@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525114152.GA10193@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 12:41:52PM +0100, Matthew Garrett wrote:
> The kernel's fine, udev isn't. Let me push the patch for that.

Er... can you be more verbose?  Or point me to a previous discussion?

>From a packaging standpoint, are distributions going to have to require
a newer udev package before the 3.5 kernel can be used?

josh
