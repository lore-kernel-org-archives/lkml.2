Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161Ab2FFUDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:03:51 -0400
Received: from www84.your-server.de ([213.133.104.84]:54587 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab2FFUDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:03:50 -0400
Message-ID: <1339013051.3437.5.camel@wall-e>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org
Date: Wed, 06 Jun 2012 22:04:11 +0200
In-Reply-To: <201206062059.25125.oliver@neukum.org>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
	 <1339000032-10313-5-git-send-email-stefani@seibold.net>
	 <201206062059.25125.oliver@neukum.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 20:59 +0200 schrieb Oliver Neukum:
> Am Mittwoch, 6. Juni 2012, 18:27:05 schrieb stefani@seibold.net:
> > 
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > this saves a litte bit of memory space in the driver devices structure
> > 
> 
> This really is the wrong way round.
> 

This was what Grek asked for. And interface is the whole driver only in
the open and close path needed.

In the open path the interface is already determinate by
usb_find_interface() so it was reasonable to do this also in the close
path.


