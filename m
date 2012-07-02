Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab2GBA3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 20:29:54 -0400
Received: from gherkin.frus.com ([192.158.254.49]:51426 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2GBA3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 20:29:53 -0400
Date: Sun, 1 Jul 2012 19:29:51 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Greg KH <gregkh@linuxfoundation.org>, Ming Lei <tom.leiming@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 3.5-rcX: USB support without udev?
Message-ID: <20120702002951.GA2184@gherkin.frus.com>
References: <20120628131651.GA14492@gherkin.frus.com> <CACVXFVNLVwNLDbpxdOMT_RCzqU=gx8O-2oZ8XQ8K87HwUBVWDA@mail.gmail.com> <20120629033600.GA3591@gherkin.frus.com> <20120630033519.GA4792@kroah.com> <20120701201411.GB8603@gherkin.frus.com> <20120701204118.GA1018@polaris.bitmath.org> <20120701232542.GA11680@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120701232542.GA11680@gherkin.frus.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2012 at 06:25:42PM -0500, Bob Tracy wrote:
> On Sun, Jul 01, 2012 at 10:41:18PM +0200, Henrik Rydberg wrote:
> > If you did a 'make oldconfig' on anything prior to -rc5, chances are
> > you do not have CONFIG_HID_GENERIC=y in your .config.
> 
> That might well be the missing "glue."  I'm building -rc5 as I type
> this.  Should have an answer in a few hours.  Thanks for the clue!

That was it!  Thank you!  Keyboard and mouse now working fine.

Unless there was a way to get the CONFIG_HID_GENERIC functionality
via some other mechanism prior to -rc5, I'd classify this as a
regression introduced in 3.5-rc1 that was fixed in -rc5.

--Bob
