Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757542Ab2F1A6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 20:58:24 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18549 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2F1A6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 20:58:23 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61a-b7f9f6d0000016a8-fc-4febac2ef6d5
Message-id: <4FEBAC2C.10402@samsung.com>
Date: Thu, 28 Jun 2012 09:58:20 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Jamie Iles <jamie@jamieiles.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] Exynos : Add support for Exynos random number generator
References: <1340793061-14260-1-git-send-email-jonghwa3.lee@samsung.com>
 <4FEB486C.7000408@codeaurora.org> <4FEBA35F.1050505@samsung.com>
In-reply-to: <4FEBA35F.1050505@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jQV29Na/9DX4/47a4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZBy6sYis4wVHx+nQrWwPjV7YuRk4OCQETiUlPDrFA2GISF+6t
	B4pzcQgJTGeUODB/HztIgldAUOLH5HtARRwczALyEkcuZYOEmQXUJSbNW8QMUd/FJLHkzHJG
	iHoNicaHvWBDWQRUJWYtuQE2h01ATuJt0zdGkDmiAhESv/o5QMIiQHO+7zgJtpdZoJtJYvfv
	LWBzhAX8JVZuPcMIsaCbUWLNxzNgQzkFtCU2L1vFOIFRYBaS+2Yh3DcLyX0LGJlXMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgQH4DOpHYwrGywOMQpwMCrx8C5a/dpfiDWxrLgy9xCjBAez
	kgjv9zigEG9KYmVValF+fFFpTmrxIUZpDhYlcd4m6wv+QgLpiSWp2ampBalFMFkmDk6pBsY1
	1dtmFp1j3mISets1iSu4/KqETI8r79IF17YrSK2Qm3Nhcd+kvp4lfzveZqkyx4j+v3D03I3Q
	XdcenT901rZ4/y/5Nm7LG88X31flVasP4g6XPcvu8EZS2Irrz8rkUE3GebH3DDO33no3y7nh
	03f9A94VdnuqzdKFjP/f+7DyScrOhb19J88rsRRnJBpqMRcVJwIAtFCTITwCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012년 06월 28일 09:20, jonghwa3.lee@samsung.com wrote:
> On 2012년 06월 28일 02:52, Stephen Boyd wrote:
>> On 06/27/12 03:31, Jonghwa Lee wrote:
>>> This patch supports Exynos SOC's PRNG driver. Exynos's PRNG has 5
seeds and
>>> 5 random number outputs. Module is excuted under runtime power
management control,
>>> so it activates only while it's in use. Otherwise it will be
suspended generally.
>>> It was tested on PQ board by rngtest program.
>>>
>>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>
>> This is an incorrect signoff chain. Kyungmin is not sending this so why
>> are you not the last one to sign off? Who is the author, Kyungmin or
>> yourself?
>>
>
>
> I'm author. Okay, I'll leave my name only.
>

Sorry I have to change my word, I can't do that. Actually, we work in
same place and he is supervisor of me. So due to our internal
regulations, we have put the supervisor's name bottom of signed-off list
conventionally. Do you want me to reverse the signed-off list?

