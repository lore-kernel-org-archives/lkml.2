Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2CMHM5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:12:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:14829 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab2CMHM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:12:56 -0400
X-AuditID: cbfee61b-b7c62ae000000989-10-4f5ef376bf99
Message-id: <4F5EF376.3060909@samsung.com>
Date: Tue, 13 Mar 2012 16:12:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Subject: Re: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
References: <4F5EDB01.9070308@samsung.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
 <CAH9JG2VrNCPMHoy5pUyc7nTzv-B7ucXheMy7PBtVUfaebt=yUA@mail.gmail.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D10@BGMAIL02.nvidia.com>
In-reply-to: <D958900912E20642BCBC71664EFECE3E6DD2912D10@BGMAIL02.nvidia.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 02:52 PM, Venu Byravarasu wrote:
>> So we decide to use legacy way. As regmap is not yet tested. So we
>> summit the current way and revise it later.
> 
> I was under the impression that regmap is stable now. Can you 
> plz let me know, what kind of problems you are seeing with 
> regmap? As I'm also planning to upstream a MFD using regmap 
> very soon, this information will be useful.

I had plan for using regmap for i2c read/write operation on later patch.
But I haven't yet tested max77693 driver with regmap for i2c,
so I posted max77693 mfd driver which was tested by using i2c legacy way.

Thank you,
Chanwoo Choi
