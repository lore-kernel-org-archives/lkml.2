Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab0KOH0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:26:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50591 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153Ab0KOH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:26:16 -0500
Date: Mon, 15 Nov 2010 08:25:45 +0100
From: Heinz Diehl <htd@fritha.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Matt <jackdachef@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, Chris Mason <chris.mason@oracle.com>
Subject: Re: dm-crypt barrier support is effective
Message-ID: <20101115072545.GA7492@fritha.org>
References: <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
 <20101107194547.GA12521@basil.fritz.box>
 <4CD71C8B.1050604@redhat.com>
 <20101107230508.GB17592@basil.fritz.box>
 <20101108145809.GD29714@redhat.com>
 <1289238930-sup-9765@think>
 <20101114205925.GA20451@redhat.com>
 <AANLkTi=rVyozmvqCJD1kGqnV3uEn-0ak6B12-O_9XOKJ@mail.gmail.com>
 <4CE05A9E.9090204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE05A9E.9090204@redhat.com>
Organization: private site
X-OpenPGP-KeyID: 0xA9353F12
X-OpenPGP-Fingerprint: C67E 9A93 1033 DF8A 9321  9F90 DC39 B8C3 A935 3F12
X-OpenPGP-URL: http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+20101028 (GNU/Linux)
X-Provags-ID: V02:K0:b3z2c3XyF/7nPQsaEwwpOuUi527Fw69IqCJn9k43utO
 PfGJCZZhHOXlwO44zyjoTAGpDbXYgaeIdaqfGYsyCQs7ttTkKh
 1xRV+QqHxnnu0iq723pP0Bme09qVTfXMk/UVG9S5nrxFNX/5pT
 f41S/kZw/9bnjHMJtaXN7Qv+robzIckCf6ATBpxiKNLOhYeCf6
 P6cyXON/FzSg8nbXk3r/g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15.11.2010, Milan Broz wrote: 

> even with v5 I sent on Friday?

Your v5 patch applies cleanly to 2.6.36, but fails to build
on my system:

[....]
LD      fs/xfs/xfs.o
LD      fs/xfs/built-in.o
CC      fs/compat_ioctl.o
drivers/md/dm-crypt.c: In function crypt_ctr':
drivers/md/dm-crypt.c:1408: error: WQ_MEM_RECLAIM' undeclared (first use in this function)
drivers/md/dm-crypt.c:1408: error: (Each undeclared identifier is reported only once
drivers/md/dm-crypt.c:1408: error: for each function it appears in.)
make[2]: *** [drivers/md/dm-crypt.o] Error 1
make[1]: *** [drivers/md] Error 2
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....
CC      fs/nfsctl.o
CC      net/netfilter/nf_sockopt.o
[....]

