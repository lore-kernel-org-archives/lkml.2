Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861Ab2ACPJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:09:24 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45444 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753694Ab2ACPJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:09:22 -0500
Date: Tue, 3 Jan 2012 10:09:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jack Stone <jwjstone@fastmail.fm>, Oliver Neukum <oliver@neukum.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
In-Reply-To: <20120103032505.GA19702@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.1201031007500.1452-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jan 2012, Matthew Garrett wrote:

> On Mon, Jan 02, 2012 at 09:45:58PM -0500, Alan Stern wrote:
> 
> > Wait a second.  Why does isight_firmware bind at this time?  Binding to
> > new devices is handled by khubd, which doesn't start running again
> > until after the resume is finished (the device appears to be new
> > because its descriptors have changed).  At that point there should be
> > no trouble reloading the firmware.
> 
> Then why are we getting this warning? The firmware is only loaded in the 
> probe function.

I don't know.  Do you have a kernel log (with CONFIG_USB_DEBUG enabled) 
posted somewhere?

Alan Stern

