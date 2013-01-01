Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab3AANGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 08:06:23 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57632 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab3AANGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 08:06:22 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Tux3 report: New news for the new year
Date: Tue, 1 Jan 2013 14:06:19 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.0-f2fs-tp520+; KDE/4.8.4; x86_64; ; )
Cc: Daniel Phillips <lkml@phunq.net>
References: <2597526.usDRg4h3X1@mars> (sfid-20130101_131559_487328_F8377415)
In-Reply-To: <2597526.usDRg4h3X1@mars>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201301011406.19983.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

Happy new year to you and everyone else!

Am Dienstag, 1. Januar 2013 schrieb Daniel Phillips:

[… long description on Tux3 design and current state …]

> We have made plausible plans for all of the above, but indeed the devil
> is in  the doing. So we are considering the merits of invoking the "many
> hands make light work" principle. Tux3 is pretty well documented and the
> code base is, if not completely obvious, at least small and orthogonal.
> Tux3 runs in userspace in two different ways: the tux3 command and fuse.
> Prototyping in user space is a rare luxury that could almost make one
> lazy. Tux3 is an entirely grassroots effort driven by volunteers.
> Nonetheless, we would welcome offers of assistance from wherever they
> may come, especially testers.

Sounds all good and nice and interesting to test, but where to grab the
source?

I found no obvious URL.


http://tux3.org/source.html:

merkaba:/tmp> git clone git://git.kernel.org/pub/scm/linux/kernel/git/daniel/linux-tux3.git
Cloning into 'linux-tux3'...
fatal: The remote end hung up unexpectedly

merkaba:/tmp> hg clone http://hg.tux3.org/tux3/ 
Abbruch: Fehler: Connection timed out


http://phunq.net/:

| Welcome to phunq.net!
| 
| Please stay tuned for more exciting developments.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
