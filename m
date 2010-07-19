Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936318Ab0GSPd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:33:58 -0400
Received: from xenotime.net ([72.52.115.56]:37284 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S936210Ab0GSPdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:33:51 -0400
Date: Mon, 19 Jul 2010 08:33:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc4, no boot
Message-Id: <20100719083340.195d4496.rdunlap@xenotime.net>
In-Reply-To: <m1aapodlby.fsf@fess.ebiederm.org>
References: <201007051250.17010.gene.heskett@gmail.com>
	<m1aapodlby.fsf@fess.ebiederm.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jul 2010 23:42:09 -0700 Eric W. Biederman wrote:

> Gene Heskett <gene.heskett@gmail.com> writes:
> 
> > Phenom 9550, 4G ram, asus m2n-sli deluxe mobo, all sata drives (4 + optical 
> > burner)
> >
> > I have now built 35-rc4 4 times, the last 2 with
> >
> > 2.6.31-12-mdv.config & make oldconfig (lots of accepts), & build
> >
> > And a working .config from 2.6.35-rc3 + make oldconfig (no changes reported) 
> > & build.
> >
> > Both fail at the attached image point booting from a grub2 menu on a 
> > different drive that has been working with rc3 for quite a few boots but its 
> > all bitchy this morning so is booted to the mdv 2.6.31-12 kernel above ATM.
> >
> > Last .config also attached.
> >
> > What do I need to do here?
> 
> That does sound bizarre.  You have some weird initrd dependency on the
> kernel doing something, but it isn't clear to me what that might be.
> Shrug.
> 
> Not being able to mount /dev and /sys feels like they simply weren't
> compiled in.  But your config suggests otherwise.

I would change the second line below to be enabled:

CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set

and give that a shot.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
