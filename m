Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab2K0Aog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 19:44:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:20076 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751789Ab2K0Aoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 19:44:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,323,1352102400"; 
   d="scan'208";a="252902633"
From: "Luck, Tony" <tony.luck@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: RE: linux-next: manual merge of the ia64 tree with Linus' tree
Thread-Topic: linux-next: manual merge of the ia64 tree with Linus' tree
Thread-Index: AQHNy2131HxZh9W9B0i7uxVX0YTNS5f82Ykw
Date: Tue, 27 Nov 2012 00:44:33 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F1C95C631@ORSMSX108.amr.corp.intel.com>
References: <20121126113141.3b624dc9e729039b54c51881@canb.auug.org.au>
In-Reply-To: <20121126113141.3b624dc9e729039b54c51881@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I fixed it up (see below) and can carry the fix as necessary.

I rebased the series onto 3.7-rc7 (using the same merge fix that you did) ... so you shouldn't see the merge error next time.

-Tony
