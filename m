Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab2ENERp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:17:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47917 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2ENERn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:17:43 -0400
Date: Sun, 13 May 2012 21:17:38 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/3] testusb: using real device-nodes managed by udev
 instead of using usbfs
Message-ID: <20120514041738.GA9750@kroah.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A060D0C@SHSMSX101.ccr.corp.intel.com>
 <20120511220920.GD13675@kroah.com>
 <0C18FE92A7765D4EB9EE5D38D86A563A062A08@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A062A08@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Mon, May 14, 2012 at 03:31:14AM +0000, Du, ChangbinX wrote:
> I am sorry I haven't consider of that. I just want testusb tool can
> work with default option since path /dev/bus/usb exists on most
> computer, not /proc/bus/usb.
> So, if I just add /dev/bus/usb to the default search path, is it ok? Thanks.

Yes, that would make more sense to do.

greg k-h
