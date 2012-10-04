Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422864Ab2JDQZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 12:25:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:37379 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933406Ab2JDQZv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 12:25:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,537,1344236400"; 
   d="scan'208";a="229965769"
From: "Luck, Tony" <tony.luck@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: [PATCH] MAINTAINERS: Add myself as the SWIOTLB maintainer.
Thread-Topic: [PATCH] MAINTAINERS: Add myself as the SWIOTLB maintainer.
Thread-Index: AQHNokmRlOK8mC80wkOoDHMGv+0DMJepVPpg
Date: Thu, 4 Oct 2012 16:25:50 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D48564@ORSMSX108.amr.corp.intel.com>
References: <1349365773-12073-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1349365773-12073-1-git-send-email-konrad.wilk@oracle.com>
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

> Now that I've an IA64 box on top of the other boxes
> (IBM with Calgary-X, Intel VT-d, AMD Vi, and AMD GART - that
> can use SWIOTLB as fallback) I can reliably do regression
> testing.

Acked-by: Tony Luck <tony.luck@intel.com>

