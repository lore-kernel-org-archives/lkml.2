Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab0CXRAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:00:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44048 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932138Ab0CXQ74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:59:56 -0400
Date: Wed, 24 Mar 2010 17:03:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324170345.1ba84093@lxorguk.ukuu.org.uk>
In-Reply-To: <132027.10140.qm@web94905.mail.in2.yahoo.com>
References: <1269448680.11714.121.camel@localhost.localdomain>
	<132027.10140.qm@web94905.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok I had a brief dig

Making a driver able to say "and open me in this ldisc" is about ten
lines of code to the core tty layer if that.

There is one caveat - the actual ldisc attach method for an ldisc attach
isn't allowed to fail the attach. That's something we eventually need to
fix anyway.

Otherwise it doesn't look too scary and it would occur when the user
opened the file not when the device was created.

Alan
