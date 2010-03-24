Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab0CXRW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:22:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38617 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754293Ab0CXRW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:22:57 -0400
Date: Wed, 24 Mar 2010 17:26:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324172647.572e3cb8@lxorguk.ukuu.org.uk>
In-Reply-To: <125378.77353.qm@web94909.mail.in2.yahoo.com>
References: <20100324170345.1ba84093@lxorguk.ukuu.org.uk>
	<125378.77353.qm@web94909.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Isn't there a mechanism for the tty_set_ldisc to do what _open does ?
> I mean there might be plenty of devices on UART which might not need /dev/tty at all ? i.e An App need not open for a ldisc to be installed.

There is no mechanism to have an open tty without having an open file
attached to it - and changing that would be very very non trivial. Plus
you still need a way to tell the kernel you want the device in question
active. That probably should get addressed some day but its not a quick
fix up!

Alan
