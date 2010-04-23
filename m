Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab0DWATO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:19:14 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33603 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0DWATM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:19:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pIPjVrqx50sY85sDuN6LbrJ1P63BskcN0VmIEy9Ipn/FUjXucI8Woz441VMNGJ518R
         dwHKOHT25bxQc5OyuZ0Erqx48EaLVa8jLKuYMa1joqLR174cG7TdOqqqn+0OBE5EP6BX
         G9Jfr9gX+K/izmIzbdX+mXOIxmfs+UIoLL1es=
Date: Thu, 22 Apr 2010 17:19:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] firmware loader: embed device into firmware_priv
 structure
Message-ID: <20100423001903.GC28213@core.coreip.homeip.net>
References: <20100314074330.27035.38765.stgit@localhost.localdomain>
 <20100314074929.27035.80425.stgit@localhost.localdomain>
 <20100423000106.GC4414@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423000106.GC4414@kroah.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 05:01:06PM -0700, Greg KH wrote:
> On Sat, Mar 13, 2010 at 11:49:29PM -0800, Dmitry Torokhov wrote:
> > Both these structures have the same lifetime rules so instead of allocating
> > and managing them separately embed struct device into struct firmware_priv.
> > Also make sure to delete sysfs attributes ourselves instead of expecting
> > sysfs to clean up our mess.
> 
> This one didn't apply due to other changes that have happened to the
> file since you sent this out.  Care to respin it?
> 

I'll wait till next next release, see what's there and resping what's
missing.

Thanks.

-- 
Dmitry
