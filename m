Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0KGUgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:36:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55916 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab0KGUgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:36:39 -0500
Date: Sun, 7 Nov 2010 21:36:37 +0100
From: Heinz Diehl <htd@fritha.org>
To: Matt <jackdachef@gmail.com>
Cc: Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        htd@fancy-poultry.org
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Message-ID: <20101107203637.GA12615@fritha.org>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
 <4CD6B7FA.3050005@redhat.com>
 <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Wanderlust/2.15.7 (Almost =?utf-8?Q?Unreal?=
 =?utf-8?B?KSBTRU1JLzEuMTQuNiAoTWFydW9rYSkgRkxJTS8xLjE0LjkgKEdvasWNKSBB?=
 =?utf-8?Q?PEL=2F10=2E7?= Emacs/22.3 (x86_64-pc-linux-gnu) MULE/5.0 (SAKAKI)
X-Provags-ID: V02:K0:81v2FeCSPRGPM6TOPhgHYUVNy3rlJT5KG0lxncyXEtt
 y7Cj2M+4bWvfrPkSp546ZTvYF91xvrLRoRFO6FhnZklJQNqlw5
 edlXm3dHoWeAwLqPKqgeKnA3dSx/UN3PTofPwvNENl5FbJRO2K
 bRH1M4vQHayoqEGnWRNX8MSqIRUuvawrFgCaqdDHsZbwPycwiA
 Kg26cCdulx3zUEWRBHm0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.2010, Matt wrote: 

> noatime,nodiratime,barrier=1

One of my systems runs a squid webcache and has a lot of disk load,
and I've never seen data loss or corruption, all the way up from 2.6.34 to
the latest -git.

(Btw: "noatime" superseeds "nodiratime", you can therefore drop it when
"noatime" is set.)

> I read about barrier-problems and data getting to the partition when
> using dm-crypt and several layers so I don't know if that could be
> related

I would rather guess that you have filesystem / harddisk problems,
but I must admit I've never mounted one of my filesystems with barriers
enabled (I use XFS exclusively).

