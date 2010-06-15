Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0FOQCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:02:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54327 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0FOQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nV8bLzyIxscqLHabrL7YBVNz1pDanG98jWq7guORDrGC0Lx+tje4aR9nh7ONCys7k/
         uhC3x7Z03F9+yOIu0VSI/2jQORJXZ8LwkkQdB8RaLwtFbxUzi8H0lG8wieZznXuFtsS3
         4IWFcV1sF/XdVL0gkQcyOk9SdO6E/lFCdopgQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimOvFsGZU6Brd-VjzBQGCoP7pgM1rO0wLrZjZZW@mail.gmail.com>
References: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
	<20100614162002.GA13902@kroah.com>
	<AANLkTinwaYy5Z528PraVuWUsU2pJBLoq0c2hgIGirTNn@mail.gmail.com>
	<4C16BFF5.7070308@gmail.com>
	<AANLkTimp4_TaQuGPlnw9ZpQCoTiTeFxtWQeZgfsdUBnK@mail.gmail.com>
	<AANLkTimOvFsGZU6Brd-VjzBQGCoP7pgM1rO0wLrZjZZW@mail.gmail.com>
Date: Wed, 16 Jun 2010 00:02:22 +0800
Message-ID: <AANLkTikjbZlzE3ibVKCm2lOi5qBnD8nRQXfv9h6cBx6z@mail.gmail.com>
Subject: Re: e-SATA ExpressCard - OOPS plus incrementing "ataX" on 
	Linux-2.6.xx
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, Greg KH <greg@kroah.com>,
       kristen.c.accardi@intel.com, Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 15, 2010 at 10:52 PM, Robert Hancock <hancockrwd@gmail.com> wrote:

> Try echoing 1 to the file for the SCSI disk's "delete" file, something
> like: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/delete

Very nice. That works!

sd 20:0:0:0: [sdb] Synchronizing SCSI cache
sd 20:0:0:0: [sdb] Stopping disk
ata17.00: disabled

/sys has so much cool things there, but I just didn't know what they were.

Thank you so much!

Jeff.
