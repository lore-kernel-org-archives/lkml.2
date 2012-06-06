Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932184Ab2FFUTt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:19:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34370 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932122Ab2FFUTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:19:45 -0400
Date: Wed, 6 Jun 2012 16:19:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefani Seibold <stefani@seibold.net>
cc: Oliver Neukum <oliver@neukum.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <alan@lxorguk.ukuu.org.uk>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 04/11] remove usb_interface pointer
In-Reply-To: <1339013051.3437.5.camel@wall-e>
Message-ID: <Pine.LNX.4.44L0.1206061617580.1183-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2012, Stefani Seibold wrote:

> Am Mittwoch, den 06.06.2012, 20:59 +0200 schrieb Oliver Neukum:
> > Am Mittwoch, 6. Juni 2012, 18:27:05 schrieb stefani@seibold.net:
> > > 
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > > this saves a litte bit of memory space in the driver devices structure
> > > 
> > 
> > This really is the wrong way round.
> > 
> 
> This was what Grek asked for. And interface is the whole driver only in
> the open and close path needed.

What about the error messages in the various callback routines?  What 
about in skel_release?

Alan Stern

