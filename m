Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0LEMuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 07:50:12 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356Ab0LEMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 07:50:10 -0500
Date: Sun, 5 Dec 2010 13:49:49 +0100
From: Heinz Diehl <htd@fritha.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>,
        htejun@gmail.com, linux-ext4@vger.kernel.org,
        Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption?
Message-ID: <20101205124949.GA8266@fritha.org>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com>
 <AANLkTinX_av7A-xT6hD-Df=tHxOOWhi7QkVezAUO3pW5@mail.gmail.com>
 <20101205100954.GA6564@fritha.org>
 <4CFB679D.5030900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFB679D.5030900@redhat.com>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:V0+VhUNMgTIQdBDU1N98MlwsLoI2fQ4Q6gOiWEIUJHb
 ZUoTVHtcJlvRC89i3i/1sa5OkgxBbjTWVMjdq16ogklAHtobZV
 xGBGwE4i2hyY7Gwn7Izgb8tE5AHuy09q6zAPwU6xWhu8Dgy7an
 Nfd6ITWQSZFZIBlunvRE23A3pPEDGficd6cFgMmWnDft5ZA9Oy
 yXIvIo6WPORP7NL0n7e5A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2010, Milan Broz wrote: 

> Which kernel? 2.6.37-rc?

2.6.37-rc4 on one and 2.6.37-rc3-git2 on the other machine.

> Anyone seen this with 2.6.36 and the same dmcrypt patch?
> (All info I had is that is is stable with here.)

Both 2.6.36 and 2.6.36.1 with your patch have been running flawlessly.
Not a single problem at all, over several weeks. 24/7.

> It still seems to like dmcrypt with its parallel processing is just
> trigger to another bug in 37-rc.

That's the impression I got, too.

