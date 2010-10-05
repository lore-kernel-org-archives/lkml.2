Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab0JENgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 09:36:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:49919 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0JENgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 09:36:13 -0400
Date: Tue, 5 Oct 2010 06:33:12 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pl2303_ttyUSB0 userspace application not able to control RTS
 line
Message-ID: <20101005133312.GF3548@suse.de>
References: <20100922052107.M44650@admin-gateway.ncra.tifr.res.in>
 <20100922145607.GB26309@suse.de>
 <20100923100127.M64470@admin-gateway.ncra.tifr.res.in>
 <20100923140236.GB31394@suse.de>
 <20100928091520.M79654@admin-gateway.ncra.tifr.res.in>
 <20100928113036.GA15024@suse.de>
 <20100928115204.M46802@admin-gateway.ncra.tifr.res.in>
 <20100928120743.GA15807@suse.de>
 <20101004042924.M50398@admin-gateway.ncra.tifr.res.in>
 <20101005104403.M28756@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005104403.M28756@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 04:33:16PM +0530, Raju Rameshwar Uprade wrote:
> Hi,
>    I am using a prolific tech USB-to-serial converter on linux kernel version 2.6.35.
> I wrote a userspace program to enable/disable RTS line which is working fine with
> standard serial port like ttyS0 and ttyS1.
> 
> But when I used the USB-to-serial port (ttyUSB0) to enable/disable the RTS line,ttyUSB0
> is not able to do that as well as some times gives
> 
> pl2303_ttyUSB0 : pl2303_open-failed submitting read urb -error 22.

Is this your "modified" driver?

I don't see that error in the kernel log below at all.

What kernel version is this?

And are you sure that your device actually has the RTS lines connected?
I have seen a number of these devices that do not bring those lines from
the chip to the rs232 connection.

You really might want to go purchase a "real" usb to serial converter
that works properly, the pl2303 devices do not fit that category.

good luck,

greg k-h
