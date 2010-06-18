Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab0FROqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:46:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:46407 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527Ab0FROqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:46:08 -0400
Date: Fri, 18 Jun 2010 07:37:27 -0700
From: Greg KH <gregkh@suse.de>
To: Daniel Sangorrin <daniel.sangorrin@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Radek Liboska <liboska@uochb.cas.cz>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: ftdi: correct merge conflict with CONTEC
 id
Message-ID: <20100618143727.GA16398@suse.de>
References: <AANLkTimx1HWYzG0qQqP12ObWQI1eiH5SoFpRic06uN3f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimx1HWYzG0qQqP12ObWQI1eiH5SoFpRic06uN3f@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 18, 2010 at 03:30:02PM +0900, Daniel Sangorrin wrote:
> This patch corrects a problem with the merge of a previous
> patch to add the CONTEC identifier.

What patch had the merge problem?  Did I just end up duplicating stuff
incorrectly?  What was the git commit id?

thanks,

greg k-h
