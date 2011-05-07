Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1EGB36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:29:58 -0400
Received: from kroah.org ([198.145.64.141]:36206 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab1EGB34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:29:56 -0400
Date: Fri, 6 May 2011 18:09:27 -0700
From: Greg KH <greg@kroah.com>
To: Maxin John <maxin.john@gmail.com>
Cc: Michal Nazarewicz <mina86@mina86.com>, gregkh@suse.de,
        stern@rowland.harvard.edu, m-sonasath@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        roger.quadros@nokia.com
Subject: Re: [PATCH] usb: gadget: f_mass_storage: Remove the LUN check which
 is always true
Message-ID: <20110507010927.GA32142@kroah.com>
References: <BANLkTik9e5it5vTMxvFUnZGpoO8N0ida8Q@mail.gmail.com>
 <op.vuynsdh13l0zgt@mnazarewicz-glaptop>
 <BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinxvtMUcFz9T7L1iq9pFUx8ocQnRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 04, 2011 at 04:04:03PM +0100, Maxin John wrote:
> Hi Michal,
> 
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> Thank you very much for reviewing the patch.
> 
> > file_storage.c has the same check, could you remove it as well.
> 
> Please find the patch for "file_storage.c" below. Should I merge these
> two patches and re-submit as a single one?

Yes please.

thanks,

greg k-h
