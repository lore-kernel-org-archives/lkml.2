Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab1KGSMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:12:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33327 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756016Ab1KGSMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:12:48 -0500
Date: Mon, 7 Nov 2011 10:12:09 -0800
From: Greg KH <gregkh@suse.de>
To: Corentin Chary <corentin.chary@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [patch 0/8] Samsung Laptop driver patches - resend
Message-ID: <20111107181209.GB5474@suse.de>
References: <20110920161743.GA32737@kroah.com>
 <CAHR064gzgKtLSNQ-NuoKWW9-Nv_S0myOusQT+-CxVVeyO5fMKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHR064gzgKtLSNQ-NuoKWW9-Nv_S0myOusQT+-CxVVeyO5fMKA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 06, 2011 at 11:54:39PM +0100, Corentin Chary wrote:
> Just got a 90X3A from Intel and I'll try to take a look at samsung-laptop
> since some features are missing (keyboard backlight for example).

Try adding your device to this driver.  Or, watch out, as newer Samsung
devices support backlight control "properly" through acpi, which is
good, and this driver is not needed by them at all.

> Do you have any doc on the vendor "interface" (other than just reading
> the code :) ) ?

I do not have any documentation for the interface, sorry.  The code
should be self-explanatory.

greg k-h
