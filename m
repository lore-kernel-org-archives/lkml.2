Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757810Ab2FFRws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 13:52:48 -0400
Received: from www84.your-server.de ([213.133.104.84]:43427 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756352Ab2FFRwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 13:52:46 -0400
Message-ID: <1339005186.11678.3.camel@wall-e>
Subject: Re: [PATCH] fix usb skeleton driver
From: Stefani Seibold <stefani@seibold.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Wed, 06 Jun 2012 19:53:06 +0200
In-Reply-To: <Pine.LNX.4.44L0.1206061252000.1788-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1206061252000.1788-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 12:55 -0400 schrieb Alan Stern:
> On Wed, 6 Jun 2012 stefani@seibold.net wrote:
> 
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This is a fix for the USB skeleton driver to bring it in shape.
> > 
> > - The usb_interface structure pointer will be no longer stored 
> > - Every access to the USB will be handled trought the usb_interface pointer
> 

Sorry, missed to fix. Should be:

Every access to the USB will be handled through the usb_device pointer

> Those two changes sound contradictory.
> 
> > - Add a new bool 'connected' for signaling a disconnect (== false)
> > - Handle a non blocking read without blocking
> > - Code cleanup
> > - Synchronize disconnect() handler with open() and release(), to fix races
> > - Introduced fsync
> > - Single user mode
> > - Eliminated dead code
> > - Save some bytes in the dev structure
> 
> How about simplifying the code so that it can be read by somebody who's 
> not already an expert?
> 
> Alan Stern
> 

Hey, i thought i get a little thank you for the voluntary work, what a
nice job. Not a demand for more work to do.


