Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab1D2C2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 22:28:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:51551 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758348Ab1D2C2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 22:28:39 -0400
Date: Thu, 28 Apr 2011 19:15:36 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 28 (staging/wlan-ng: prism2)
Message-ID: <20110429021536.GB22138@suse.de>
References: <20110428152534.7240a49c.sfr@canb.auug.org.au>
 <20110428092917.039071a4.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110428092917.039071a4.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 09:29:17AM -0700, Randy Dunlap wrote:
> On Thu, 28 Apr 2011 15:25:34 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> 
> 
> drivers/staging/wlan-ng/prism2fw.c:1115: warning: the frame size of 4288 bytes is larger than 2048 bytes
> 
> Noooooo.

Heh.  What caused this?  I don't remember changing anything here
recently.

thanks,

greg k-h
