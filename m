Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab1EGPmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 11:42:24 -0400
Received: from kroah.org ([198.145.64.141]:40796 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506Ab1EGPmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 11:42:11 -0400
Date: Sat, 7 May 2011 08:43:07 -0700
From: Greg KH <greg@kroah.com>
To: Maxin John <maxin.john@gmail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, gregkh@suse.de,
        stern@rowland.harvard.edu, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        roger.quadros@nokia.com
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
Message-ID: <20110507154307.GE23672@kroah.com>
References: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
 <op.vuynsdh13l0zgt@mnazarewicz-glaptop>
 <BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
 <20110507010927.GA32142@kroah.com>
 <BANLkTikPgm7kpaoofVSkJCBXYyea4HeB8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikPgm7kpaoofVSkJCBXYyea4HeB8A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 07, 2011 at 12:27:58PM +0300, Maxin John wrote:
> Hi Greg,
> 
> >> Please find the patch for "file_storage.c" below. Should I merge these
> >> two patches and re-submit as a single one?
> >
> > Yes please.
> 
> As per your suggestion, please find the merged patch below:
> 
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Ok, but you forgot a changelog entry and a good subject line.

Care to redo this in a format that I don't have to edit it in order to
be able to apply it properly?

thanks,

greg k-h
