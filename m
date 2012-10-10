Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2JJUfE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 16:35:04 -0400
Received: from foo.stuge.se ([212.116.89.98]:42226 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757192Ab2JJUfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 16:35:01 -0400
Message-ID: <20121010203459.20663.qmail@stuge.se>
Date: Wed, 10 Oct 2012 22:34:59 +0200
From: Peter Stuge <peter@stuge.se>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: REGRESSION: usbdevfs:
	Use-scatter-gather-lists-for-large-bulk-transfers
Mail-Followup-To: Henrik Rydberg <rydberg@euromail.se>,
	Hans de Goede <hdegoede@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20121010203118.GA792@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121010203118.GA792@polaris.bitmath.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hej Henrik,

Henrik Rydberg wrote:
> commit 3d97ff63f8997761f12c8fbe8082996c6eeaba1a
> Author: Hans de Goede <hdegoede@redhat.com>
> Date:   Wed Jul 4 09:18:03 2012 +0200
> 
>     usbdevfs: Use scatter-gather lists for large bulk transfers
>     
> breaks an usb programming cable over here. The problem is reported as
> "bulk tranfer failed" [sic] by the tool, and bisection leads to this
> commit. Reverting on top of 3.6 solves it for me.
> 
> I am happy to test alternatives.

In order to make full use of the new kernel commit you also need
changes in libusb, if the tool uses libusb, but I agree that the
kernel change must under no circumstance cause existing userland
software to regress.

What is the programming cable and software that uses it?


//Peter
