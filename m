Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030179Ab2GCAlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:41:00 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54625 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933144Ab2GCAk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:40:58 -0400
Date: Mon, 2 Jul 2012 20:40:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Frederik Himpe <fhimpe@telenet.be>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
        <linux-uvc-devel@lists.sourceforge.net>
Subject: Re: Logitech HD Webcam C525 does not work when connected to USB 2
 port, works on USB 3
In-Reply-To: <1341259950.4325.11.camel@piranha.localdomain>
Message-ID: <Pine.LNX.4.44L0.1207022039360.27935-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012, Frederik Himpe wrote:

> > Have you tried using the webcam on a different computer?
> 
> I just tried it on a different system (Dell Latitude E6400), and it
> worked fine on the USB2 ports (kernel version was 3.4.1 on that system,
> though). The webcam also works fine on the affected system and USB2
> ports in Windows.

What happens if you disable USB runtime suspend on the affected system?  
Windows tends not to use it.

Alan Stern

