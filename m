Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2HKW4a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 18:56:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33469 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2HKW4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 18:56:14 -0400
Date: Sat, 11 Aug 2012 15:56:09 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, Matthias Urlichs <smurf@smurf.noris.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [Regression, post-3.5] NULL pointer dereference in usb-wwan
 after resume from system suspend
Message-ID: <20120811225609.GA20031@kroah.com>
References: <201208120039.19463.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208120039.19463.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2012 at 12:39:19AM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> The usb-wwan driver triggers a NULL pointer dereference oops after resume
> from system suspend on my Toshiba Portege R500, but since that driver
> hasn't changed since v3.5 and it is only used by the option driver, I suppose
> that the latter is responsible for that.
> 
> This is a clear regression from v3.5, it hasn't happened ever before.
> 
> I'll collect some details tomorrow.

Known bug, we have a fix for it in the usb-next tree now, it will be
going to Linus in a few days.

If you want, I can dig up the patch for it and send it to you, if it's
stopping other things from working for you at the moment.

thanks,

greg k-h
