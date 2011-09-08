Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545Ab1IHX62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:58:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876Ab1IHX60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:58:26 -0400
Date: Thu, 8 Sep 2011 12:11:46 -0700
From: Greg KH <gregkh@suse.de>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20110908191146.GA8552@suse.de>
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 08:24:47PM +0200, Klaus Schwarzkopf wrote:
> This driver provides two functions in one configuration:
> a mass storage, and a CDC ACM (serial port) link.
> Heavily based on multi.c and cdc2.c

I thought the "composite" framework make it so that drivers like this
were no longer needed.  Or am I mistaken somehow?

> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.

Do you really mean "any later version"?

> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

These two paragraphs are not needed, and the address is a very bad idea
to include in any file as it changes over time and I don't think you
want to keep up with the address location of the FSF for the next 40+
years.

As an example of this, I am starting to get patches from the FSF to fix
up old addresses, 10 years after moving their office...

thanks,

greg k-h
