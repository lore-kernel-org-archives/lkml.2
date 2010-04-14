Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757132Ab0DNWyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:54:18 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42215 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756958Ab0DNWyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jB2YAf/6npAP407z70Y1nxg4PVPXM4lCRiF+ASEehM/DBaeU13EXMaWK83yYvG1EdT
         owVpsJ+WNtLEws5kTYHrMUz+SEhAl0KZ/n0pMDXAobrYR8ajQWOJL8OCMSPJGaLcAuKJ
         Bur9TSzMzt3C8RUweEfFnq006MObcU6Kc5Rv0=
Date: Wed, 14 Apr 2010 15:54:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: add HP Compaq 2710p to 'noloop' table
Message-ID: <20100414225407.GA12143@core.coreip.homeip.net>
References: <alpine.LNX.2.00.1004141409450.8345@pobox.suse.cz>
 <20100414160429.GC2450@core.coreip.homeip.net>
 <alpine.LNX.2.00.1004142354330.8345@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1004142354330.8345@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 11:57:04PM +0200, Jiri Kosina wrote:
> On Wed, 14 Apr 2010, Dmitry Torokhov wrote:
> 
> > > Add HP Compaq 2710p to 'noloop' table. Otherwsie this machine is reported 
> > > to not report properly to AUX_LOOP command time-to-time, causing 
> > > non-working keyboard due to messed up i8042.
> > > 
> > 
> > What is the chassis type for the box in DMI? I am curious why it isn't
> > caought up by the generic "portable" test...
> 
> Hmm, you are right, I completely forgot that we are now completely 
> bypassing AUX IRQ delivery on Portable/Laptop/(Sub-)Notebook chasis types.
> 
> I was going through my older patchqueue and flushing it, and this one 
> slipped through, as it is apparently not necessary for current mainline 
> (the machine in question has chasis type "Notebook"), but only for older 
> kernels.
> 

OK, thanks.

-- 
Dmitry
