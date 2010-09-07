Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0IGTMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:12:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:44025 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757579Ab0IGTMi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:12:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,329,1280732400"; 
   d="scan'208";a="604724199"
From: "Luck, Tony" <tony.luck@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "hpa@zytor.com" <hpa@zytor.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Woodhouse, David" <david.woodhouse@intel.com>,
        "Brown, Len" <len.brown@intel.com>, Chris Wright <chrisw@sous-sol.org>,
        Yinghai Lu <yinghai@kernel.org>
Date: Tue, 7 Sep 2010 12:12:36 -0700
Subject: RE: [PATCH 09/10] x86/VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_*
 macros.
Thread-Topic: [PATCH 09/10] x86/VT-d: Make Intel VT-d IOMMU use IOMMU_INIT_*
 macros.
Thread-Index: ActOwBET/s3CvhtDQSmRpPHodCzZnwAAHb3A
Message-ID: <987664A83D2D224EAE907B061CE93D53015DB0EF3D@orsmsx505.amr.corp.intel.com>
References: <1282845485-8991-1-git-send-email-konrad.wilk@oracle.com>
 <1282845485-8991-10-git-send-email-konrad.wilk@oracle.com>
 <AANLkTikcdyNP8x28u3-m0oNcOqSek=xwUn3wW-=3sqnY@mail.gmail.com>
 <20100907190729.GA6668@dumpdata.com>
In-Reply-To: <20100907190729.GA6668@dumpdata.com>
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

> If you do this patch it should compile fine, let me think a bit about
> how to make the iommu_* pieces platform-agnostic.


Yes. That fixes the compliation problem.

-Tony
