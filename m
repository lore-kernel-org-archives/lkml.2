Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2CMFwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:52:30 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12349 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444Ab2CMFw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:52:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 12 Mar 2012 22:52:28 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
CC: Chanwoo Choi <cw00.choi@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Date: Tue, 13 Mar 2012 11:22:24 +0530
Subject: RE: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Thread-Topic: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Thread-Index: Ac0A26hdAQrcqa/5TFuCUpk+X+tXMwAAUnDQ
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD2912D10@BGMAIL02.nvidia.com>
References: <4F5EDB01.9070308@samsung.com>
	<D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
 <CAH9JG2VrNCPMHoy5pUyc7nTzv-B7ucXheMy7PBtVUfaebt=yUA@mail.gmail.com>
In-Reply-To: <CAH9JG2VrNCPMHoy5pUyc7nTzv-B7ucXheMy7PBtVUfaebt=yUA@mail.gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So we decide to use legacy way. As regmap is not yet tested. So we
> summit the current way and revise it later.

I was under the impression that regmap is stable now. Can you 
plz let me know, what kind of problems you are seeing with 
regmap? As I'm also planning to upstream a MFD using regmap 
very soon, this information will be useful.

