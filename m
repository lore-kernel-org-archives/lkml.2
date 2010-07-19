Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936179Ab0GSPkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 11:40:40 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47976 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935158Ab0GSPki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 11:40:38 -0400
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-rc4, no boot
References: <201007051250.17010.gene.heskett@gmail.com>
	<m1aapodlby.fsf@fess.ebiederm.org>
	<20100719083340.195d4496.rdunlap@xenotime.net>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 19 Jul 2010 08:40:34 -0700
In-Reply-To: <20100719083340.195d4496.rdunlap@xenotime.net> (Randy Dunlap's message of "Mon\, 19 Jul 2010 08\:33\:40 -0700")
Message-ID: <m1mxtn7a4t.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> writes:

> On Sun, 18 Jul 2010 23:42:09 -0700 Eric W. Biederman wrote:
>
>> Gene Heskett <gene.heskett@gmail.com> writes:
>> 
>> > Phenom 9550, 4G ram, asus m2n-sli deluxe mobo, all sata drives (4 + optical 
>> > burner)
>> >
>> > I have now built 35-rc4 4 times, the last 2 with
>> >
>> > 2.6.31-12-mdv.config & make oldconfig (lots of accepts), & build
>> >
>> > And a working .config from 2.6.35-rc3 + make oldconfig (no changes reported) 
>> > & build.
>> >
>> > Both fail at the attached image point booting from a grub2 menu on a 
>> > different drive that has been working with rc3 for quite a few boots but its 
>> > all bitchy this morning so is booted to the mdv 2.6.31-12 kernel above ATM.
>> >
>> > Last .config also attached.
>> >
>> > What do I need to do here?
>> 
>> That does sound bizarre.  You have some weird initrd dependency on the
>> kernel doing something, but it isn't clear to me what that might be.
>> Shrug.
>> 
>> Not being able to mount /dev and /sys feels like they simply weren't
>> compiled in.  But your config suggests otherwise.
>
> I would change the second line below to be enabled:
>
> CONFIG_DEVTMPFS=y
> # CONFIG_DEVTMPFS_MOUNT is not set
>
> and give that a shot.

That is such a truly evil option. *shiver*

Eric
