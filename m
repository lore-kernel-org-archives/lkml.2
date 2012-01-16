Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab2APRtF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 12:49:05 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56269 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755634Ab2APRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 12:49:03 -0500
X-Sasl-enc: +hzl6aNraZ35tTO2bMIfhPn+n/5J1FcAHLuNXBHr0sL3 1326736140
Date: Mon, 16 Jan 2012 09:37:26 -0800
From: Greg KH <greg@kroah.com>
To: Praveen kumar <chatpravi@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Subject: Re: USB controller status
Message-ID: <20120116173726.GA18147@kroah.com>
References: <CAOzqYK6+6ML=HqYOk_gJaAzB=5v_wDEzMs7C_YDgMHmB2LtWHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOzqYK6+6ML=HqYOk_gJaAzB=5v_wDEzMs7C_YDgMHmB2LtWHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 04:15:09PM +0530, Praveen kumar wrote:
> Hi All,
>         As part of diagnostics  I have to make sure the USB controller is
> configured correctly.

How can it not be configured correctly?

> Can I get this information from any entry in /sys or /proc ?? If yes where ??
> If no I plan to add a exclusive entry in the driver to do my diagnostics.

What type of diagnostics are you trying to do?

> Is that feasible by reading some of the registers in
> the controller ??

You have looked at the debugfs files for the usb controllers for this
type of thing already, right?

greg k-h
