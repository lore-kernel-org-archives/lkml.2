Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2HCOqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:46:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55605 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753056Ab2HCOqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:46:39 -0400
Date: Fri, 3 Aug 2012 10:46:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Virupax SADASHIVPETIMATH <virupax.sadashivpetimath@stericsson.com>
cc: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Praveena NADAHALLY <praveen.nadahally@stericsson.com>,
        Vikrant BAPAT <vikrant.bapat@stericsson.com>,
        Rajaram REGUPATHY <ragupathy.rajaram@stericsson.com>
Subject: RE: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
In-Reply-To: <A3217089E06965468FCEC60ADC3A8F925C21599D6E@EXDCVYMBSTM006.EQ1STM.local>
Message-ID: <Pine.LNX.4.44L0.1208031046260.1520-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012, Virupax SADASHIVPETIMATH wrote:

> > This is unacceptable.  Fields like this should be stored in the
> > URB's hcpriv structure, not in the URB itself.
> 
> Ok I will add it in the hcpriv structure. Can you please comment on other
>  part of the code also, so that all the changes can be done together. 

I have no other comments.

Alan Stern

