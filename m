Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab0KDUql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:46:41 -0400
Received: from nm1-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.202]:37284 "HELO
	nm1-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752867Ab0KDUqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:46:40 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 568012.41125.bm@omp1036.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=NeM7MPLnGdRlHzUDgX2gnUh1wATX5hBDLdHd9oeE9YXyUwWOhLo9oHrhRZQKTxORNtwvRuwosGD6KSQC1W2Nh1w8QdhjWfigtGT9EsWXElm/aevQriRL/7+RLd4HnGpqWKV4YyIjym3wC9yfabzLwhEDe9c8jM0eZsiwEMQQjXo=;
Message-ID: <596240.50099.qm@web180307.mail.gq1.yahoo.com>
X-YMail-OSG: b62iuLIVM1n4D72omCoLa8FHJwXWCJHkisrd.sS21LoDwh_
 5vJIfiWtai0P8iCUeP9Cn0mZ7pAgssab7TiyGQNtCc7mc534xXgzBFTiN1eV
 mpIKAULe7MHSRCpAWs_nEutvojeSa1Vcsr11Wzjr6CAAWXKvTURdbYvSanyK
 Iqx2R8vgeJa4RD1BHx3.PDXKkKYIwjeOMo0gRmPck3yPl2UNZqaxF2arBSfJ
 yIaxmBL_ur02aDcOFDCywkygZSm1OjHMxLQ9dsLcLPf3KsG6LpBeDkzlIH6Q
 trVpjIRcjyUifloqnypNO6Umfx4gTjGj2yQCRZAXHZVwrq2ucBwM3Xq2AgCf
 oiw--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.107.284920
Date: Thu, 4 Nov 2010 13:19:58 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: spi_butterfly null ptr dereference on unload module
To: lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 11/4/10, Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Date: Thursday, November 4, 2010, 12:46 PM
> Just load and unload the module.

For the record ... at first impression this
feels like a regression in another part of
the kernel than the driver you indicate.
I used to do that load/unload semi-regularly,
with no errors appearing.

However, I can't do any real testing on this,
now, since I no longer have parport-capable
hardware to which I can hook up one of these adapters ... and thus collect more info about
where the bit-rot has rooted.

- Dave


