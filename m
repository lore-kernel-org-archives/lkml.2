Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab0KPVnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:43:11 -0500
Received: from tango.0pointer.de ([85.214.72.216]:53062 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480Ab0KPVnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:43:10 -0500
Date: Tue, 16 Nov 2010 22:42:50 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Werner Fink <werner@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101116214250.GB17824@tango.0pointer.de>
References: <1289922400.1253.3.camel@yio.site>
 <20101116155717.6671e484@lxorguk.ukuu.org.uk>
 <AANLkTimn7zyEjLhmOmUVQGnLDfM-A_uEgWETsM3nsyuY@mail.gmail.com>
 <20101116171447.29336514@lxorguk.ukuu.org.uk>
 <AANLkTi=ju4fON7Hz=j_tFtqFGD0b-c=-Ou+HQwfYDgOy@mail.gmail.com>
 <20101116195538.7fa66b97@lxorguk.ukuu.org.uk>
 <AANLkTinXy3pNhwqo5aqHrH9fN99JhJrBtnbbpnq2h_K-@mail.gmail.com>
 <20101116204906.29d840e9@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101116204906.29d840e9@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16.11.10 20:49, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> /dev/tty* and sysfs nodes don't track permissions, owner with each other,
> so you are providing interfaces that either expose information they
> shouldn't (which screen is valuable info in some environments), or don't
> expose info they should.

Well, I find the informatoin who is logged in much more valuable then
the information whether I am active or not. And the who is logged in
informatin I can find out with a simple stat() on the tty caller.

> sysfs also lacks vhangup so you can't fix it right now either.

Which is a feature, no a bug. It would be kinda messy if the service
which manages device access based on whose session is active would
always be forcibly stopped from doing so if somebody calls vhangup().

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
