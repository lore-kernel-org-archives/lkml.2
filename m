Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0LDUvo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 15:51:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831Ab0LDUvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 15:51:41 -0500
Date: Sat, 4 Dec 2010 21:51:20 +0100
From: Heinz Diehl <htd@fritha.org>
To: Matt <jackdachef@gmail.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Milan Broz <mbroz@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>,
        htejun@gmail.com, linux-ext4@vger.kernel.org,
        Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Message-ID: <20101204205120.GA17542@fritha.org>
References: <4CE05A9E.9090204@redhat.com>
 <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
 <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com>
 <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
 <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com>
 <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:9ufTnXWwX6DeFk2KgbXnT+H6zZyzOi3lHkowCYZ+siH
 4BjizB5Scyd3L8+byUSr7R+pbuDDnf1SnY6Msut0DBvOODABG+
 8p1RUyt1s1VVZJ8L7WOJaXOV9l3JajvNUYbhvYXA0lOEu28N3F
 Ipf5bMiKubGCrnnZhjhQbsTEVBWUo2Uo4m+MtDa3+cXGysK8ra
 bI8GsHRx5hYLtb9XxjvZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.12.2010, Matt wrote: 

> I'm not sure if it's even a problem with ext4 - I haven't had the time
> to test with XFS yet

I can and have run both -rc3 and -rc4 with Milans patch v6, without any problems at
all, under heavy load and disk I/O. I'm using XFS exclusively. The system
is a testing server and contains 3 harddisks, 2 SATA disks and one SSD.
The whole system runs flawlessly, without any corruption...






