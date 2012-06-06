Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2FFHpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:45:47 -0400
Received: from www84.your-server.de ([213.133.104.84]:46295 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2FFHpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:45:46 -0400
Message-ID: <1338968766.4143.6.camel@wall-e>
Subject: Re: [PATCH] fix usb skeleton driver
From: Stefani Seibold <stefani@seibold.net>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk
Date: Wed, 06 Jun 2012 09:46:06 +0200
In-Reply-To: <201206060929.02676.oneukum@suse.de>
References: <1338966036-30443-1-git-send-email-stefani@seibold.net>
	 <201206060929.02676.oneukum@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 06.06.2012, 09:29 +0200 schrieb Oliver Neukum:
> Am Mittwoch, 6. Juni 2012, 09:00:36 schrieb stefani@seibold.net:
> > From: Stefani Seibold <stefani@seibold.net>
> > 
> > This is a fix for the USB skeleton driver to bring it in shape.
> > 
> > - The usb_device structure pointer will no longer stored 
> > - Every access to the USB will be handled trought the usb_interface pointer
> > - No longer assign a NULL to usb_interface pointer in the disconnect() handler
> 
> Why? What is gained?
> 

All of this topics was suggested by Greg.

If a NULL is assigned to the usb_interface pointer, the skel_delete
cannot do an usb_put_dev() since the usb_device pointer is no longer
available.

Greetings

