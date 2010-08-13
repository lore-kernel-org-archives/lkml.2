Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934324Ab0HMNEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 09:04:33 -0400
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:57398 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab0HMNEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 09:04:31 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2010 09:04:31 EDT
Subject: Re: [patch] usb/serial/ssu100: uninitialized variable
To: error27@gmail.com (Dan Carpenter)
Date: Fri, 13 Aug 2010 08:58:24 -0400 (EDT)
Cc: gregkh@suse.de (Greg Kroah-Hartman), linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20100813123811.GA31262@bicker>
X-Mailer: ELM [version 2.5.8.52.g5a79]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100813125824.87BC52389B@viridian.itc.virginia.edu>
From: wfp5p@viridian.itc.virginia.edu (Bill Pemberton)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> GCC complains about the original code, because we're using an
> unintialized variable "flag".  I think we should be setting flag based
> on the UART_LSR_BRK_ERROR_BITS but I'm not sure...  I don't have this
> hardware.  Probably passing TTY_NORMAL is better than the current code?
> 

I took that function from ftdi_sio and stripped a lot out of it
while developing the driver.  I see I missed adding back in the logic
dealing with setting flag correctly.  I'll work up a patch to properly
deal with it.

-- 
Bill
