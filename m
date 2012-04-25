Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2DYQtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 12:49:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:30320 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab2DYQty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 12:49:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="136657904"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
CC: Borislav Petkov <borislav.petkov@amd.com>
Subject: RE: [PATCH 0/3] AMD thresholding fixes
Thread-Topic: [PATCH 0/3] AMD thresholding fixes
Thread-Index: AQHNIvtkzZVErTAdqEG8SZHz5PajwparwALA
Date: Wed, 25 Apr 2012 16:49:52 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F170F3C53@ORSMSX104.amr.corp.intel.com>
References: <1335369123-23196-1-git-send-email-bp@amd64.org>
In-Reply-To: <1335369123-23196-1-git-send-email-bp@amd64.org>
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

> If there are no issues, I'll add the queue to linux-next (I don't see a
> branch from ras.git in linux-next, btw, which is strange).

Patches so far have been flowing from "ras" to "tip" to "linus". It
hasn't quite been clear how linux-next fits into this. If we export
to -next, then are we planning on sending those directly to linus,
bypassing tip?

-Tony
