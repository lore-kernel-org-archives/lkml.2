Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0ESIea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 04:34:30 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49337 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0ESIe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 04:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tBAMB8rFaEcQY1KR1CBGttvBrHHmPTO60EuWaXtuELml7Np28/XwiWraKi1oHhd+8z
         KLRnV+v7pXkqCOcEyOAPluCn6oKhMZsVHhnQG7jKdVmjk5aZJD/mRkno+d7Kr/HcP03u
         IIV2xVb5QBA1BX9BVgfrjBg76blMRWGp/9Ne4=
Date: Wed, 19 May 2010 12:34:22 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       kay.sievers@vrfy.org, dwmw2@infradead.org,
       broonie@opensource.wolfsonmicro.com, len.brown@intel.com,
       astarikovskiy@suse.de, mreimer@vpop.net, zbr@ioremap.net, tj@kernel.org
Subject: Re: [PATCH] power/ds2760_battery: document ABI change
Message-ID: <20100519083422.GA31202@oksana.dev.rtsoft.ru>
References: <20100517194016.GA12147@oksana.dev.rtsoft.ru>
 <1274212193-16669-2-git-send-email-daniel@caiaq.de>
 <20100518195624.GA20057@suse.de>
 <20100518203049.GK30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100518203049.GK30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 10:30:49PM +0200, Daniel Mack wrote:
> >From 7ed6b078c1cb718509a0faf79ac53f768fa5cfc4 Mon Sep 17 00:00:00 2001
> From: Daniel Mack <daniel@caiaq.de>
> Date: Tue, 18 May 2010 22:26:40 +0200
> Subject: [PATCH] power/ds2760_battery: document ABI change
> 
> Add some documentation for the newly added writeable properties.
> 

I added 'Suggested-by: Greg KH <gregkh@suse.de>' tag here.

> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> ---
> On Tue, May 18, 2010 at 12:56:24PM -0700, Greg KH wrote:
> > On Tue, May 18, 2010 at 09:49:52PM +0200, Daniel Mack wrote:
> > > This patch adds support for writeable power supply properties and
> > > exposes them as writeable to sysfs.
> > 
> > Please properly document this in Documentation/ABI as you are changing
> > the userspace ABI.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Is something like the following appropriate?

Looks good to me, as well as patches 1-3 (though in the first patch
I fixed power_supply_attr_groups to be static, it was a negligence
from my original patch).

I applied all these patches to battery-2.6.git, thanks!

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
