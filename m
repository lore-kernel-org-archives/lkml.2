Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab0G1KlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 06:41:19 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:52354 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab0G1KlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 06:41:16 -0400
X-IronPort-AV: E=Sophos;i="4.55,273,1278302400"; 
   d="scan'208";a="19592026"
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: Joe Perches <joe@perches.com>, Mike Frysinger <vapier.adi@gmail.com>
CC: uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Date: Wed, 28 Jul 2010 11:41:11 +0100
Subject: RE: [Uclinux-dist-devel] [PATCH net-next] drivers/net/bfin_mac.c:
 Use  pr_fmt, netdev_<level>
Thread-Topic: [Uclinux-dist-devel] [PATCH net-next] drivers/net/bfin_mac.c:
 Use  pr_fmt, netdev_<level>
Thread-Index: AcsuO768Y0V5OJRUQo2bAZ0QiKg1uAAABb6g
Message-ID: <544AC56F16B56944AEC3BD4E3D5917712E7EC22B1B@LIMKCMBX1.ad.analog.com>
References: <1280258531.24054.10.camel@Joe-Laptop.home>
	 <AANLkTi=p=-ovBaqyqBdEW=W4E1ArWsiyUBwy37GtXOyu@mail.gmail.com>
 <1280311240.24054.103.camel@Joe-Laptop.home>
In-Reply-To: <1280311240.24054.103.camel@Joe-Laptop.home>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o6SAfPM7027844

Joe Perches wrote on 2010-07-28:
> On Wed, 2010-07-28 at 03:50 -0400, Mike Frysinger wrote:
>> On Tue, Jul 27, 2010 at 15:22, Joe Perches wrote:
>>> $ ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
>>> total: 2 errors, 25 warnings, 1723 lines checked $
>>> ./scripts/checkpatch.pl -f drivers/net/bfin_mac.c | grep "^total:"
>>> total: 0 errors, 0 warnings, 1743 lines checked
>> i dislike the mixing of whitespace and useful changes if they were
>> split, and they worked, then i wouldnt have a problem with them
>
> Is that a nak or a dislike?

I think what Mike meant was - two patches would be better.
I'm currently cloning the tree this patch applies to.
I'll ACK once I verified the patch.

>
> Also, is Michael Hennerich actually the maintainer for bfin_mac?
> He had been  listed as MAINTAINER for over a year but he hasn't ever
> written or acked a patch for this file.
>
> commit making Michael Hennerich bfin_mac MAINTAINER $ git log -1
> 6c83429a commit 6c83429a1c32c914dfb81939cc2ddece97e48294
> Author: Mike Frysinger <vapier@gentoo.org>
> Date:   Sun May 24 02:13:15 2009 -0400
>
>     MAINTAINERS: update Blackfin items
>
>     With Bryan Wu having moved on to another job, push the slack onto
>     some other ADI lackeys.
>
>     Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> $ ./scripts/get_maintainer.pl -f drivers/net/bfin_mac.c \
>       --rolestats --git-since=5-years-ago --nol Michael Hennerich
> <michael.hennerich@analog.com> (supporter:BLACKFIN EMAC DRIVER) "David
> S. Miller" <davem@davemloft.net> (commit_signer:41/65=63%) Jeff Garzik
> <jgarzik@redhat.com> (commit_signer:31/65=48%) Bryan Wu
> <cooloney@kernel.org> (commit_signer:26/65=40%) Mike Frysinger
> <vapier@gentoo.org> (commit_signer:20/65=31%) Sonic Zhang
> <sonic.zhang@analog.com> (commit_signer:8/65=12%)
>
>

Greetings,
Michael

Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft Muenchen, Registergericht Muenchen HRB 4036 Geschaeftsfuehrer Thomas Wessel, William A. Martin, Margaret Seif


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
