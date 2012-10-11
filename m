Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2JKG51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 02:57:27 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34295 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab2JKG5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 02:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20121011065033.2168.qmail@stuge.se>
References: <20121010203118.GA792@polaris.bitmath.org>
	<20121010203459.20663.qmail@stuge.se>
	<20121011054403.GA1680@polaris.bitmath.org>
	<20121011065033.2168.qmail@stuge.se>
Date: Thu, 11 Oct 2012 14:57:23 +0800
Message-ID: <CAGjSPUC+_4g8KiUCvUWgc8QN4KaprTXXK29+2Pzq7sH3Lickpg@mail.gmail.com>
Subject: Re: REGRESSION: usbdevfs: Use-scatter-gather-lists-for-large-bulk-transfers
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>, Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Stuge <peter@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 2:50 PM, Peter Stuge <peter@stuge.se> wrote:
> But it isn't certain that is is involved at all. If your impact
> version uses libusb.so like in ISE 11.1 then it will not be. One way
> to test is by trying to generate a libusb debug log. See
> https://libusb.org/wiki/debug for instructions which are for libusb,
> but which work also for libusbx since the code is nearly the same.
> (Just replace the repository to clone from.)

Actually this is not that correct. For libusbx, you do not need
to rebuild libusbx to get the debug log at all, just need to
set environment variable LIBUSB_DEBUG=4 to get the
debug log.

Also it seems to me Xilinx is using libusb-1.0 API now.
http://www.xilinx.com/support/documentation/sw_manuals/xilinx14_1/pim_t_linux_cable_drivers.htm



-- 
Xiaofan
