Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1LIUCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:02:53 -0500
Received: from mga14.intel.com ([143.182.124.37]:39083 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1LIUCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:02:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="84125454"
From: "Luck, Tony" <tony.luck@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 9 Dec 2011 12:02:48 -0800
Subject: RE: linux-next: build failure after merge of the final tree (pci
 tree related)
Thread-Topic: linux-next: build failure after merge of the final tree (pci
 tree related)
Thread-Index: Acy2JiQllMmt9lAiQ7K5y7OIKsDL1QAhluTw
Message-ID: <0207C53569FE594381A4F2EB66570B2A018EFB78F3@orsmsx508.amr.corp.intel.com>
References: <20111207170533.3dea865573c916e79d274eca@canb.auug.org.au>
 <CAErSpo59CuEBbu4QWMkK23TyXafhMLOh1G7Z8YxojqiQmCM0Fw@mail.gmail.com>
 <20111208072412.e9cf00f9bcdbc4450fe2d2d4@canb.auug.org.au>
 <CA+8MBb+n_y=BGQihjGujAq7=cUwpdOTP0-7uRoftFeXouD=QHw@mail.gmail.com>
 <CAErSpo4V4Nhga5q7wHSiLmr4LubV4Sy+8gMZuob+163ZOHr__Q@mail.gmail.com>
In-Reply-To: <CAErSpo4V4Nhga5q7wHSiLmr4LubV4Sy+8gMZuob+163ZOHr__Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sigh, I'm sorry.  Attached are the incremental patch to fix this, and
> an updated version of the original patch.  I'm not git-smart enough to
> push it this time (the box where I normally do that is down at the
> moment, along with my notes).

Bjorn,

Thanks - the incremental patch works great.

-Tony
