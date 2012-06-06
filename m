Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab2FFHr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:47:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225Ab2FFHr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:47:28 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: [PATCH] fix usb skeleton driver
Date: Wed, 6 Jun 2012 09:44:13 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk
References: <1338966036-30443-1-git-send-email-stefani@seibold.net> <201206060929.02676.oneukum@suse.de> <1338968766.4143.6.camel@wall-e>
In-Reply-To: <1338968766.4143.6.camel@wall-e>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206060944.13894.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 6. Juni 2012, 09:46:06 schrieb Stefani Seibold:
> Am Mittwoch, den 06.06.2012, 09:29 +0200 schrieb Oliver Neukum:
> > Am Mittwoch, 6. Juni 2012, 09:00:36 schrieb stefani@seibold.net:
> > > From: Stefani Seibold <stefani@seibold.net>
> > > 
> > > This is a fix for the USB skeleton driver to bring it in shape.
> > > 
> > > - The usb_device structure pointer will no longer stored 
> > > - Every access to the USB will be handled trought the usb_interface pointer
> > > - No longer assign a NULL to usb_interface pointer in the disconnect() handler
> > 
> > Why? What is gained?
> > 
> 
> All of this topics was suggested by Greg.
> 
> If a NULL is assigned to the usb_interface pointer, the skel_delete
> cannot do an usb_put_dev() since the usb_device pointer is no longer
> available.

Yes, that's true. Sorry for the confusion.

	Regards
		Oliver
