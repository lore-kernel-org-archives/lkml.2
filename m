Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab0CXQyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:54:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53309 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756579Ab0CXQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:54:12 -0400
Date: Wed, 24 Mar 2010 16:58:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Marcel Holtmann <marcel@holtmann.org>, Greg KH <gregkh@suse.de>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324165800.722086c3@lxorguk.ukuu.org.uk>
In-Reply-To: <12213.61465.qm@web94909.mail.in2.yahoo.com>
References: <1269447105.11714.117.camel@localhost.localdomain>
	<12213.61465.qm@web94909.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The core of the problem is we cannot ask/install/ldisc_put for a line discipline from kernel space.

The device is always in WL protocol mode and starts this way ?

If so lets simply fix the tty layer to allow a driver to set the initial
ldisc.

> The only reason I wanted this to be in staging was to have sort of continuous review process, and in hope the driver wouldn't be forgotten.

I would certainly prefer this as it is much easier to refine this way

Alan
