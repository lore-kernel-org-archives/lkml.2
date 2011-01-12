Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab1ALQxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 11:53:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:52415 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab1ALQxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 11:53:38 -0500
Date: Wed, 12 Jan 2011 16:53:35 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Anca Emanuel <anca.emanuel@gmail.com>, Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for rc1
In-Reply-To: <4D2DBC2C.6070301@de.ibm.com>
Message-ID: <alpine.LFD.2.00.1101121653180.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
 <alpine.LFD.2.00.1101121344070.8212@casper.infradead.org> <4D2DBC2C.6070301@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am 12.01.2011 14:45, schrieb James Simmons:
> >> I tested the revert: the boot screen did change the resolution
> >> (without it don't), but my PC still hangs. (using an nvidia 8800GT).
> > 
> > Try my most recent patch. Where does it hang at? Any logs?
> 
> FYI, I just want to mention that with the latest git+the fix 
> X11 sometimes consumes 100% cpu for a long time. Dont know if
> this is a related problem or not.

I doubt they are related.

