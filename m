Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2JVWpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 18:45:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54414 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab2JVWpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 18:45:09 -0400
Date: Mon, 22 Oct 2012 15:45:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, devel@driverdev.osuosl.org,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] staging: Add firewire-serial driver
Message-ID: <20121022224505.GD24489@kroah.com>
References: <1350565015.23730.4.camel@thor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350565015.23730.4.camel@thor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 08:56:55AM -0400, Peter Hurley wrote:
> Please consider this serial driver for review for submission to staging.
> The firewire-serial driver implements TTY over IEEE 1394. In its default
> configuration, it creates 4 TTY devices and one loopback device per
> firewire card (respectively, named fwtty<n>~fwtty<n+3> and fwloop<n>).
> 
> Currently, the TTY devices auto-connect to every cabled peer (the TODO
> list includes plans for providing a sysfs interface to control virtual
> cabling with whitelist/blacklist support per GUID).
> 
> Efforts are still ongoing for a companion console driver, with plans to
> eventually add early_printk & kgdb support (via additional drivers).
> 
> Some issues did arise with both the TTY and Firewire subsystems which
> are noted in the TODO file. Please review these workarounds.
> 
> Peter Hurley (1):
>   staging: fwserial: Add TTY-over-Firewire serial driver

I'd like to get an Ack from Stefan here, before I'll add this to the
staging tree.

thanks,

greg k-h
