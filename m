Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2BVCTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:19:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:17955 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab2BVCTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:19:31 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-89-4f4450b10078
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Chris Ball'" <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <20120222124915.9414928ca50d8b181820c733@canb.auug.org.au>
In-reply-to: <20120222124915.9414928ca50d8b181820c733@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the mmc tree with the s5p tree
Date: Wed, 22 Feb 2012 11:19:28 +0900
Message-id: <012701ccf108$67a1ef80$36e5ce80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczxBU5w9fNgXaz/TbOqqDzr3GOCzgAAqWDA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Chris,
> 
Hi Stephen,

> Today's linux-next merge of the mmc tree got a conflict in
> drivers/mmc/host/sdhci-s3c.c between commit bd0955ed6b1b ("mmc:
> sdhci-s3c: add platform data for the second capability") from the s5p
> tree and commit 7880741a0625 ("mmc: sdhci-s3c: derive transfer width host
> capability from max_width in platform data") from the mmc tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Look ok to me, and let me carry following when it is required.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

