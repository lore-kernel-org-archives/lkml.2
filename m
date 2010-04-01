Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab0DAXXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:23:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33448 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752241Ab0DAXX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:23:29 -0400
Date: Fri, 2 Apr 2010 00:27:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging: sources for ST core
Message-ID: <20100402002731.1b8fd3b0@lxorguk.ukuu.org.uk>
In-Reply-To: <215529.2509.qm@web94907.mail.in2.yahoo.com>
References: <488000.27888.qm@web94909.mail.in2.yahoo.com>
	<215529.2509.qm@web94907.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry but I can't make head or tail of this and the code flow you are
trying to achieve.

The usual way you do stuff is to put per device stuff in a per device
struct, driver wide stuff in a driver struct (or static variables) and
then run everything from the device end.

I'd expect a low level driver to do something like


	probe()
		create device entry
		initialise device (eg download firmware)
		register itself with anything higher level

