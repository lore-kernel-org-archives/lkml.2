Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab0LAT7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:59:47 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58958 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab0LAT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:59:45 -0500
Date: Wed, 1 Dec 2010 20:59:39 +0100
From: Heinz Diehl <htd@fritha.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>,
        htejun@gmail.com
Subject: Re: dm-crypt barrier support is effective
Message-ID: <20101201195939.GA6491@fritha.org>
References: <20101108145809.GD29714@redhat.com>
 <1289238930-sup-9765@think>
 <20101114205925.GA20451@redhat.com>
 <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
 <4CE05A9E.9090204@redhat.com>
 <AANLkTimT0t3xqgKdAn7MBPD7ED-9uPS+WJE0z+K8tciu@mail.gmail.com>
 <AANLkTik_p0yxQBQ3ehHWYPLfiqxGbSNUT5XUk9dC5-x6@mail.gmail.com>
 <20101201165229.GC13415@redhat.com>
 <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF692D1.1010906@redhat.com>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Wanderlust/2.15.7 (Almost =?utf-8?Q?Unreal?=
 =?utf-8?B?KSBTRU1JLzEuMTQuNiAoTWFydW9rYSkgRkxJTS8xLjE0LjkgKEdvasWNKSBB?=
 =?utf-8?Q?PEL=2F10=2E7?= Emacs/22.3 (x86_64-pc-linux-gnu) MULE/5.0 (SAKAKI)
X-Provags-ID: V02:K0:4qo+ODVu23z26iR3KafrPuLjWxOIAwK9LzI6q1NBPjG
 gE6UIXvCDGba6BTMYeT8AVcWwVJsRAJuLAtpIee13yuhRXaKBS
 alNKtNCnQ8fqL4YvpINdJUDXTl0/hOzsjoPxWJJbxLIqZ+D9eJ
 UenrPER5EXYJRw1axdy0Zok570d26KPkzix5CSBiun6P3WlAav
 STdb3H9ZSfVTU9w20B8fw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2010, Milan Broz wrote: 

> Anyway, I run several tests on 2.6.37-rc3+ and see no integrity
> problems (using xfs,ext3 and ext4 over dmcrypt).

Not that this might help, but just for testing purposes, I have run all 
the -rcX from 2.6.36 on with Milan's patch (XFS filesystem) under heavy 
load and disk i/o, and have not encountered a single problem or corruption.

