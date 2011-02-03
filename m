Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487Ab1BCTEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:04:13 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:49380 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab1BCTEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:04:11 -0500
Date: Thu, 3 Feb 2011 19:55:16 +0100
From: Nico Schottelius <nico-kernel-20110117@schottelius.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Nico Schottelius <nico-kernel-20110117@schottelius.org>
Subject: Re: [Bug #28102] New display errors in 2.6.38-rc2-00175-g6fb1b30
Message-ID: <20110203185516.GA2560@schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-kernel-20110117@schottelius.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>,
	Florian Mickler <florian@mickler.org>
References: <QUnbpYCwS-F.A.vaC.VHeSNB@chimera>
 <ibChAs1xEQI.A.0gC.aHeSNB@chimera>
 <20110203101111.35d71bf0@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203101111.35d71bf0@jbarnes-desktop>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: kr (Linux 2.6.37 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson <chris@chris-wilson.co.uk>:

> This should hopefully find the culprit:
> $ git bisect start drivers/gpu/drm/i915/intel_display.c
> $ git bisect good v2.6.37
> $ git bisect bad
 
Just went that path, compiled 2.6.37-rc4-00292-g3c8cdf9
and suspended which resulted in a completly dead device
(no ping, no ctrlaltdel possible), i.e. different fatal situation.

I'm a bit confused, not sure whether this is related to
the broken display issue or not.

As the tests always cost a quite lengthy fsck run, I'd
love to go a different way from 2.6.37, if anybody has
a better hint.

Cheers,

Nico

-- 
PGP key: 7ED9 F7D3 6B10 81D7 0EC5  5C09 D7DC C8E4 3187 7DF0
