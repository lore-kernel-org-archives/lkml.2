Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946251Ab2EKWJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:09:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47666 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab2EKWJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:09:24 -0400
Date: Fri, 11 May 2012 15:09:20 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Du, ChangbinX" <changbinx.du@intel.com>
Cc: "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/3] testusb: using real device-nodes managed by udev
 instead of using usbfs
Message-ID: <20120511220920.GD13675@kroah.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A060D0C@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A060D0C@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 11:02:01AM +0000, Du, ChangbinX wrote:
> As the usbfs functionality have replaced by real device-nodes managed by udev whose nodes lived in /dev/bus/usb for a long time, testusb tool need update correspondingly.

Why?  Is this causing problems as it is today?

> Because udev path is fixed, so the "-A" option no longer need and it is removed.

Did you just break scripts that was using that option?  That's not nice,
and not acceptable.

greg k-h
