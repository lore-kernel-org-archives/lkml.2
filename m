Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2COKNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 06:13:11 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36316 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2COKNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 06:13:06 -0400
X-AuditID: cbfee61a-b7b78ae000001ceb-7e-4f61c0afb578
Message-id: <4F61C0AE.7070201@samsung.com>
Date: Thu, 15 Mar 2012 19:13:02 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Subject: Re: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
References: <4F5EDB01.9070308@samsung.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
 <CAH9JG2VrNCPMHoy5pUyc7nTzv-B7ucXheMy7PBtVUfaebt=yUA@mail.gmail.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D10@BGMAIL02.nvidia.com>
 <20120314172101.GA13393@sirena.org.uk>
In-reply-to: <20120314172101.GA13393@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 03/15/2012 02:21 AM, Mark Brown wrote:
> On Tue, Mar 13, 2012 at 11:22:24AM +0530, Venu Byravarasu wrote:
>>> So we decide to use legacy way. As regmap is not yet tested. So we
>>> summit the current way and revise it later.
> 
>> I was under the impression that regmap is stable now. Can you 
>> plz let me know, what kind of problems you are seeing with 
>> regmap? As I'm also planning to upstream a MFD using regmap 
>> very soon, this information will be useful.
> 
> Yes, it should be very stable.  Personally my primary development
> systems have PMICs which use regmap and most of my work is on regmap
> based device so I'll probably notice if there's an issue.

OK, I shortly discussed using regmap for i2c read/write, you can
identify it on following url.
I will apply regmap to max77693 on next version patch.
- https://lkml.org/lkml/2012/3/13/111


Best regards,
Chanwoo Choi
