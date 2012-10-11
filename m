Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2JKHMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:12:30 -0400
Received: from foo.stuge.se ([212.116.89.98]:54520 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753679Ab2JKHM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:12:28 -0400
Message-ID: <20121011071226.3909.qmail@stuge.se>
Date: Thu, 11 Oct 2012 09:12:26 +0200
From: Peter Stuge <peter@stuge.se>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: usbdevfs:
	Use-scatter-gather-lists-for-large-bulk-transfers
Mail-Followup-To: Xiaofan Chen <xiaofanc@gmail.com>,
	Henrik Rydberg <rydberg@euromail.se>,
	Hans de Goede <hdegoede@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121010203118.GA792@polaris.bitmath.org> <20121010203459.20663.qmail@stuge.se> <20121011054403.GA1680@polaris.bitmath.org> <20121011065033.2168.qmail@stuge.se> <CAGjSPUC+_4g8KiUCvUWgc8QN4KaprTXXK29+2Pzq7sH3Lickpg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGjSPUC+_4g8KiUCvUWgc8QN4KaprTXXK29+2Pzq7sH3Lickpg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaofan Chen wrote:
> On Thu, Oct 11, 2012 at 2:50 PM, Peter Stuge <peter@stuge.se> wrote:
> > But it isn't certain that is is involved at all. If your impact
> > version uses libusb.so like in ISE 11.1 then it will not be. One way
> > to test is by trying to generate a libusb debug log. See
> > https://libusb.org/wiki/debug for instructions which are for libusb,
> > but which work also for libusbx since the code is nearly the same.
> > (Just replace the repository to clone from.)
> 
> Actually this is not that correct. For libusbx, you do not need
> to rebuild libusbx to get the debug log at all, just need to
> set environment variable LIBUSB_DEBUG=4 to get the
> debug log.

The configure option to completely disable logging is still present
in libusbx, and I do not know which distributions use that, if any,
so I prefer to recommend the method that is guaranteed to work.


//Peter
