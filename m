Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0IMPtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 11:49:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:47495 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab0IMPtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 11:49:39 -0400
Date: Mon, 13 Sep 2010 08:48:43 -0700
From: Greg KH <gregkh@suse.de>
To: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Regarding USB-to-Serial device driver
Message-ID: <20100913154843.GA27496@suse.de>
References: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913091318.M67834@admin-gateway.ncra.tifr.res.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 02:47:45PM +0530, Raju Rameshwar Uprade wrote:
> output of usbmon tell that data going out properly, but it's going in chunks,Ideally It
> should go out in one chunk.I think I have to take care of RTS line. UART drivers works
> in that way,RTS is enabled for complete data out ,then it is disabled so that we can get
> device response.

usb to serial devices are known for sending data in "chunks", that's the
way the devices work (cheap, tiny, 8bit microcontrollers in the device)
and they break things up like this all the time.

If this is an issue, I suggest buying a high-cost usb to serial device
that has a real uart in them and can handle high data rates at constant
speeds.  The I/O devices (now made by digi) do this, and I think a
number of keyspan devices also work well, but it's been a long time
since I tested them.

good luck,

greg k-h
