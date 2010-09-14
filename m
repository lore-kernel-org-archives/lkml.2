Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0INNb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:31:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40492 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0INNb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:31:58 -0400
Date: Tue, 14 Sep 2010 06:19:25 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-Serial device driver
Message-ID: <20100914131925.GC375@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in>
 <20100913154843.GA27496@suse.de>
 <20100914060649.M96376@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100914060649.M96376@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 14, 2010 at 11:41:42AM +0530, Raju Rameshwar Uprade wrote:
>  
> > usb to serial devices are known for sending data in "chunks", that's the
> > way the devices work (cheap, tiny, 8bit microcontrollers in the device)
> > and they break things up like this all the time.
> > 
> 
>  Greg,
>       I am able to send data bytes properly.One problem, I am currently facing is to
> enable Address parity and Data parity.
> 
> For Address parity we have to give a mark parity ( 0x04 ).
> For Data parity we have to give a space parity ( 0x05 ).
> I don't know how I can enable parity in pl2303.c.

Enable it like you would for any other serial port from userspace using
the proper termios bits.

good luck,

greg k-h
