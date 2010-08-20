Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab0HTDzs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 23:55:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab0HTDzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 23:55:45 -0400
Date: Thu, 19 Aug 2010 20:56:32 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: Marek Vasut <marek.vasut@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, maxinbjohn@gmail.com,
        orest.bond@outpostembedded.com, vijaykumar@zilogic.com
Subject: Re: Regarding USB-Serial Device driver
Message-ID: <20100820035632.GA7349@suse.de>
References: <20100819055329.M29689@admin-gateway.ncra.tifr.res.in> <20100819061525.M24093@admin-gateway.ncra.tifr.res.in> <201008190938.44532.marek.vasut@gmail.com> <20100819141812.GA12375@suse.de> <20100820033259.M54157@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820033259.M54157@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Fri, Aug 20, 2010 at 09:12:56AM +0530, Raju Rameshwar Uprade wrote:
> Hello Greg,
>               
>              No the driver is not working properly for me.I have connected RS-485
> interface card to the USB-Serial adaptor through which I am controlling six MCM card(
> Control & Monitor unit). When I send command to MCM 2 , command also goes to MCM 10 & 0.
> When I checked on the oscilloscope, I found out that instead of going some ten bytes,
> large number of bytes are going out.

Is the data going to the usb device properly?  You can use usbmon to see
this.

> Current kernel version have that RTS support, but for 2.6.25 it doesn't have. 

2.6.25 is many years old and not supported by any community member.
Please use something more recent like 2.6.35.

> I am having confusion that form where so many bytes are going out.
> If you can help me out,I would be very thankful to you.

I don't know the changes you made, can you please show them in diff
format?

thanks,

greg k-h
