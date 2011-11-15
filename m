Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1KOH0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 02:26:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16643 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1KOH0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 02:26:23 -0500
X-AuditID: cbfee61b-b7b7fae000005864-48-4ec2141de1d4
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>
References: <20111111131159.848e724c5a9257d0b9f0f0f9@canb.auug.org.au>
 <201111101941.59570.dmitry.torokhov@gmail.com>
 <20111111165741.5a6d5f14ad70f98776d3b39a@canb.auug.org.au>
In-reply-to: <20111111165741.5a6d5f14ad70f98776d3b39a@canb.auug.org.au>
Subject: RE: linux-next: manual merge of the input tree with the s5p tree
Date: Tue, 15 Nov 2011 16:26:21 +0900
Message-id: <004501cca367$dfbbd650$9f3382f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcygNt8vKdLlDRewR+iOTflh0T4P8gDMLLLw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> 
> Hi Dmitry,
> 
> On Thu, 10 Nov 2011 19:41:59 -0800 Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > Please drop the whole HAVE_SAMSUNG_KEYPAD thing; HAVE_CLK is all
> > this driver needs. Expanding beyond Samsung will allow greater
> > compile coverage.
> 
> OK, I have modified the conflict resolution for tomorrow.
> 
OK, I will git-revert it in my tree.

Sorry for late response.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

