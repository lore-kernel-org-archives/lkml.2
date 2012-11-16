Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001Ab2KPHqJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:46:09 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:48308 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750730Ab2KPHqI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:46:08 -0500
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Xi Wang <xi.wang@gmail.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 15 Nov 2012 23:39:47 -0800
Subject: RE: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
Thread-Topic: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
Thread-Index: Ac2+gFSWPrY4h7gFTjaTPyad+f70IgFQixtg
Message-ID: <F766E4F80769BD478052FB6533FA745D25EA94A704@SC-VEXCH4.marvell.com>
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>
  <1352145183-29355-3-git-send-email-xi.wang@gmail.com>
 <1352203618.2529.22.camel@dabdike> <50997955.10000@gmail.com>
 <F766E4F80769BD478052FB6533FA745D25EA5FB180@SC-VEXCH4.marvell.com>
 <509D08B5.2080303@gmail.com>
In-Reply-To: <509D08B5.2080303@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Xi

> > About patch 3, I check the ffz code and found it will check ~0 conditions.
> 
> Can you point me to the ~0 check in ffz code?  I also feel like using
> __ffs64 makes the code simpler.
Yes, it seem to be ok

> 
> Does patch 1 look good to you?  Thanks.
> 
Yes

Thanks!

