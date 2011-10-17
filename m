Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab1JQVS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 17:18:56 -0400
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:40942 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754090Ab1JQVSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 17:18:54 -0400
MIME-Version: 1.0
In-Reply-To: <4E976147.9030000@xenotime.net>
References: <20111013181606.a204565fad9caaa0fe680b75@canb.auug.org.au> <4E976147.9030000@xenotime.net>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 17 Oct 2011 14:18:30 -0700
X-Google-Sender-Auth: Wv6i841EqjSnut-wIInjczk89w4
Message-ID: <CAL1RGDXqQ+5W2LH5c6jzR6_AygcJ+Xh=0fcHga=Ps8rjEnPE8w@mail.gmail.com>
Subject: Re: [PATCH -next] infiniband: fix printk format in hw/nes_cm.c
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Faisal Latif <faisal.latif@intel.com>,
        Linux RDMA <linux-rdma@vger.kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, rolled this into the offending commit.
