Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab2HGII0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 04:08:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23209 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2HGIIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 04:08:20 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-13-5020ccf3116f
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <20120802084154.875a13db0ec1ebd3f5a4dab3@canb.auug.org.au>
In-reply-to: <20120802084154.875a13db0ec1ebd3f5a4dab3@canb.auug.org.au>
Subject: RE: linux-next: removal of some trees
Date: Tue, 07 Aug 2012 17:08:18 +0900
Message-id: <097401cd7473$ce075320$6a15f960$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1wNvCOUZUxrdPxSBKFjjYdQHLvEwAYUFGw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jAd3PZxQCDOZ/4bS4vGsOm8XBhW2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWsf9XKWtDFXjFr0k6WBsbHrF2MnBwSAiYSx89OZ4Ow
	xSQu3FsPZHNxCAksYpRYd+AYO4Tzl1Hiy82tLCBVbAIaEoffP2MHsUUEAiS+Xd/IDGIzC7hK
	zN57kwnEFhJwk1izag1QDQcHp4C7xMUjLiBhYQE9iT8X1oKVsAioSvw/8guslVfAVuL/9KVs
	ELagxI/J91ggRmpJrN95nAnClpfYvOYtM8hICQF1iUd/dSEuMJI4NbWPHaJERGLfi3eMExiF
	ZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBAP5PawbiyweIQ
	owAHoxIP7wRZhQAh1sSy4srcQ4wSHMxKIryHdwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xp7
	f/UXEkhPLEnNTk0tSC2CyTJxcEo1MBbyFnytnq9bP+fQF+nUFpY1n/f+2nJIrenTpgZenX+t
	v/WWpcQxmm/ofpv16+UFzyCWw6HePiUb7I5+ZvV2a9n3gLGz4s/K+X5Gp4MOvrnFpsIyaWGP
	c+tn0f3ygrZ815PvnJmpv8+pv1dw1qrQbReMEuX7+Riurt6dPCXNS/39Ruk8c5FFt5RYijMS
	DbWYi4oTAfpfLelkAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Ben,
> 
> Since I haven't been able to fetch these trees for quite some time and I
> haven't heard from you about them, I am removing the following trees from
> linux-next.  If/When you have time to maintain these trees again, we can
> add them back without problems.
> 
> samsung	 	git://git.fluff.org/bjdooks/linux.git#next-samsung
> bjdooks-i2c	git://git.fluff.org/bjdooks/linux.git#next-i2c
> 
Hi Stephen,

I think, now, the 'samsung' can be removed from linux-next but I'm not sure
about 'bjdooks-i2c'. If so, please change the name of my tree 's5p' to
'samsung'.

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
#for-next

If any problems, please kindly let me know.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

