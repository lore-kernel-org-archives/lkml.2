Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0GXVRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 17:17:15 -0400
Received: from v-smtp-auth-relay-2.gradwell.net ([79.135.125.41]:56825 "EHLO
	v-smtp-auth-relay-2.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966Ab0GXVRO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 17:17:14 -0400
Subject: Re: support for drives larger than 2TiB
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: Valdis.Kletnieks@vt.edu
Cc: ben.collins@ubuntu.com, Jeff Garzik <jeff@garzik.org>,
        Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        hmh@debian.org
In-Reply-To: <92061.1279979348@localhost>
References: <4C4AB952.9030705@kernel.org>
	 <1279974966.11927.26.camel@lithium.local.net>  <92061.1279979348@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Sat, 24 Jul 2010 22:15:38 +0100
Message-ID: <1280006138.11927.61.camel@lithium.local.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-24 at 09:49 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sat, 24 Jul 2010 13:36:06 BST, Alex Buell said:
> 
> > The only thing that would please me no end with newer replacements for
> > BIOS is the ability to have 4k boot sectors. Imagine what we can do with
> > 4k what we can't do with 512 bytes. 
> 
> Are you saying that 4K sectors have some special nice implications for the boot
> process, or that the boot process is the last major hangup to fully supporting
> a device with 4K sectors, which would give us an 8X boost in capacity on all
> the codepaths that work via sector humbers?  I suspect you mean the latter, but
> it's early in the morning  still.. ;)

It would be interesting to see how newer BIOSses cope with 4k boot
sectors. I'm sure the latest ATAPI standards do allow 4k boot sectors, I
just want to know how this will be implemented for devices with larger
physical sectors than the more usual 512 byte sectors. 

> As a side consideration - moving from 512 to 4K moves the associated limit from
> 2 TiB to 16 TiB.  Given the current rate of device density increase, how much
> time will that buy us, and what do we do then?

There are now 3TB devices out there. But noone can boot from 4k devices
yet on existing PC systems. 

I'm sure a market to provide 3rd party BIOSes able to do this will
develop shortly. I know of one: coreboot. 
-- 
http://www.munted.org.uk

One very high maintenance cat living here.
