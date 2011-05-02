Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1EBJDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:03:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37980 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab1EBJDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=O1z5lUY/Ai/rv+Zm2H2qzrQoPRk1OiBunkAI1jTZCErcSjIcaDx2ObtXS5SIbckYGK
         NQcfEu5n1a77vSaJX6Y6YD4X4nSQXT4MaRGwpxNnH//Uwl/LkumL61Cby0xbLVSzRQ3w
         C6IAWRHwoOWU48OUHGn06oxpV+yinK62vfWYU=
Subject: Re: [PATCH] Fix the over time interface of the driver-model docs
From: "wanlong.gao" <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110502032906.GA1553@kroah.com>
References: <1304229056-5554-1-git-send-email-wanlong.gao@gmail.com>
	 <20110501195939.c0ae66cc.rdunlap@xenotime.net>
	 <20110502032906.GA1553@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Linux kernel
Date: Mon, 02 May 2011 17:02:59 +0800
Message-ID: <1304326979.1777.1.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2011-05-01日的 20:29 -0700，Greg KH写道：
> On Sun, May 01, 2011 at 07:59:39PM -0700, Randy Dunlap wrote:
> > On Sun,  1 May 2011 13:50:56 +0800 wanlong.gao@gmail.com wrote:
> > 
> > > From: Wanlong Gao<wanlong.gao@gmail.com>
> > > 
> > > The driver-model documentation seems like out-of-date, Can we
> > > fix them or rewrite ?
> > 
> > GregKH should get this patch.......
> > 
> > 
> > > Signed-off-by: Wanlong Gao<wanlong.gao@gmail.com>
> > > ---
> > >  Documentation/driver-model/bus.txt    |   32 ++++----
> > >  Documentation/driver-model/device.txt |  149 +++++++++++++++++++--------------
> > >  2 files changed, 104 insertions(+), 77 deletions(-)
> > > 
> > > diff --git a/Documentation/driver-model/bus.txt b/Documentation/driver-model/bus.txt
> > > index 5001b75..82bca26 100644
> > > --- a/Documentation/driver-model/bus.txt
> > > +++ b/Documentation/driver-model/bus.txt
> > > @@ -5,21 +5,23 @@ Definition
> > >  ~~~~~~~~~~
> > >  
> > >  struct bus_type {
> > > -	char			* name;
> > > +	const char		*name;
> > > +	struct bus_attribute	*bus_attrs;
> > > +	struct device_attribute	*dev_attrs;
> > > +	struct driver_attribute	*drv_attrs;
> 
> 
> <snip>
> 
> This should almost all removed from these files and moved to be
> kerneldoc in the device.h file instead.  That will keep things up to
> date and provide a better way to document this stuff.
> 
> Wanlong, can you do that instead?
> 
> thanks,
> 
> greg k-h

Greg:
I see, I'll try to do it .
Thanks
Best regards

Wanlong Gao

