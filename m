Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1HAWZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 18:25:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab1HAWZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 18:25:39 -0400
Date: Mon, 1 Aug 2011 15:24:29 -0700
From: Greg KH <gregkh@suse.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Andiry Xu <andiry.xu@amd.com>, Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH][Resend] USB: Remove test for NULL that'll never happen
 in usb_disconnect()
Message-ID: <20110801222429.GB5853@suse.de>
References: <alpine.LNX.2.00.1108020001310.31999@swampdragon.chaosbits.net>
 <20110801221019.GA22726@xanatos>
 <20110801222405.GA5853@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801222405.GA5853@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 03:24:05PM -0700, Greg KH wrote:
> On Mon, Aug 01, 2011 at 03:10:19PM -0700, Sarah Sharp wrote:
> > Hi Jesper,
> > 
> > You probably need to send this directly to Greg, instead of to the list.
> 
> He copied me :)
> 
> > I'm not sure if Greg's still on vacation, so resend in a couple days if
> > you don't hear from him.
> 
> I'm back, but digging out from a huge load of todo work, so it will be a
> while before getting to non-3.1-bugfix patches (unlike this one.)

s/unlike/like/

