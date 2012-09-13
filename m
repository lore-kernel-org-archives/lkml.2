Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab2IMDKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 23:10:17 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61770 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2IMDKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 23:10:14 -0400
MIME-Version: 1.0
X-Originating-IP: [59.167.234.130]
In-Reply-To: <CAOzFzEhU6Y2hbRKU9qdFbtx_A-+wgs14E8Xza107G+z7uHzs_w@mail.gmail.com>
References: <20120905100724.GA27527@soda.linbit>
	<20120906212952.GP29092@google.com>
	<20120907084221.GD7028@soda.linbit>
	<20120910225442.GE7677@google.com>
	<20120910230654.GF7677@google.com>
	<20120910233159.GE19739@google.com>
	<20120911155820.74f1f918@notabene.brown>
	<20120911082501.GH7028@soda.linbit>
	<20120912185824.GS7677@google.com>
	<CAOzFzEjCf7ZPbheq-tfhts-E=Ep1kvn0muksaaTFqJ=cMm772w@mail.gmail.com>
	<20120912232019.GW7677@google.com>
	<CAOzFzEhfoCpGCy0n5cu60xz+tSbB26g1f2ztcD1DwZOY-6aTwQ@mail.gmail.com>
	<CAOzFzEhU6Y2hbRKU9qdFbtx_A-+wgs14E8Xza107G+z7uHzs_w@mail.gmail.com>
Date: Thu, 13 Sep 2012 13:10:13 +1000
Message-ID: <CAOzFzEg754UM_+Zzet2XB_gNOui3-hURskP2GAhr49J6-PBBHA@mail.gmail.com>
Subject: Re: [Drbd-dev] FLUSH/FUA documentation & code discrepancy
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>, Kent Overstreet <koverstreet@google.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Vivek Goyal <vgoyal@redhat.com>, drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun, list.

While reviewing some of the documentation in Documentation/block I
found there is still out of date references to the old barrier code.
Should this also be removed?
I am not sufficiently confident of my understanding of the block layer
to do a through review/update of the Documentation/block stuff but my
untrained eye suggests maybe that such a undertaking is probably abit
overdue.


-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
