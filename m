Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122Ab2IGID1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:03:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:3449 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab2IGIDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:03:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219230793"
Date: Fri, 7 Sep 2012 16:03:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: Bob Liu <lliubbo@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: BF561-EZKIT-SMP_defconfig build error in smp.c
Message-ID: <20120907080319.GA19102@localhost>
References: <CAA_GA1f=NvzNOpuKg7mO8TnvFXjtZDHBjBeXkSihV94eWRkncA@mail.gmail.com>
 <20120808070449.GA19904@localhost>
 <CAA_GA1fuEamnDoSk8ki-nXGY5k2t9BsPkfFaGmNPQ2A=MuV-Og@mail.gmail.com>
 <20120824090324.GA3878@localhost>
 <CAA_GA1dMk8TJ3Nv5vTRquBO3aRfdFbxpq9=+uVnF30tO3ymiSw@mail.gmail.com>
 <20120904095654.GA12384@localhost>
 <CAA_GA1cEhn6dKg2Q7fH4tJRJ2a+qryukHP84OKCm8Lb15phB8w@mail.gmail.com>
 <20120907070705.GA18082@localhost>
 <CAA_GA1eQ1WbnZDaSaLXhAo7Txt+v2WScDhF8_D3r0tHtZV8Xug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA_GA1eQ1WbnZDaSaLXhAo7Txt+v2WScDhF8_D3r0tHtZV8Xug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

FYI, BF561-EZKIT-SMP_defconfig has this build error:

kernel/built-in.o: In function `on_each_cpu mask':
kernel/smp.c:708: undefined reference to `smp_call_function_many'

Thanks,
Fengguang
