Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab0ELQ6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 12:58:30 -0400
Received: from kroah.org ([198.145.64.141]:59283 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518Ab0ELQ63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 12:58:29 -0400
Date: Wed, 12 May 2010 09:56:45 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: gregkh@suse.de, Lennart Poettering <mzxreary@0pointer.de>,
       Richard Purdie <rpurdie@linux.intel.com>,
       "Lee, Chun-Yi" <jlee@novell.com>, linux-kernel@vger.kernel.org,
       platform-driver-x86@vger.kernel.org
Subject: [PATCH 0/4] msi-laptop patches
Message-ID: <20100512165645.GA27064@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's some msi-laptop.c patches that Joey has found necessary for some
newer MSI models.  Please apply them to your tree, or let us know if
there are any problems with them.

thanks,

greg k-h
