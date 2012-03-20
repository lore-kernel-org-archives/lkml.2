Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab2CTN74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:59:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33113 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2CTN7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:59:55 -0400
Date: Tue, 20 Mar 2012 06:59:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Andrey Moshbear <andrey.vul@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: usb-storage: don't remove device if unrecognized partition table
Message-ID: <20120320135951.GC4634@kroah.com>
References: <CAFnZeoRg_uU6wH3Bb8Lapkr_3oDGL0nqh0o17ePK2M1Jj2C86A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFnZeoRg_uU6wH3Bb8Lapkr_3oDGL0nqh0o17ePK2M1Jj2C86A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 09:58:37PM -0400, Andrey Moshbear wrote:
> Is there a way to set the kernel to not unregister a USB mass storage
> device if the partition table is unrecognized?
> 
> I have a Xbox 360 HD connected to a generic SATA-USB bridge, but the
> proprietary partition table means that the
> device unregisters before I have a chance to intercept in, e.g. virtualbox.

The device should not be unregistered, what is the kernel log entries
for it?

greg k-h
