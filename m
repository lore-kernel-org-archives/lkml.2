Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299Ab0GTPCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:02:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40905 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194Ab0GTPC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:02:29 -0400
Date: Tue, 20 Jul 2010 17:02:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Kulikov Vasiliy <segooon@gmail.com>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Patterson, Andrew D (LeftHand Networks)" <andrew.patterson@hp.com>,
        ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 01/16] trivial: use ARRAY_SIZE
In-Reply-To: <0F5B06BAB751E047AB5C87D1F77A77887D03473B46@GVW0547EXC.americas.hpqcorp.net>
Message-ID: <alpine.LNX.2.00.1007201702020.4741@pobox.suse.cz>
References: <1277726085-24434-1-git-send-email-segooon@gmail.com> <0F5B06BAB751E047AB5C87D1F77A77887D03473B46@GVW0547EXC.americas.hpqcorp.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Miller, Mike (OS Dev) wrote:

> > Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> Acked-by: Mike Miller <mike.miller@hp.com>

Not present in linux-next as of today. Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
