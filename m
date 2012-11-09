Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2KINoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:44:25 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:61459 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2KINoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:44:24 -0500
Message-ID: <509D08B5.2080303@gmail.com>
Date: Fri, 09 Nov 2012 08:44:21 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Xiangliang Yu <yuxiangl@marvell.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] [SCSI] mvsas: fix shift in mvs_94xx_free_reg_set()
References: <1352145183-29355-1-git-send-email-xi.wang@gmail.com>  <1352145183-29355-3-git-send-email-xi.wang@gmail.com> <1352203618.2529.22.camel@dabdike> <50997955.10000@gmail.com> <F766E4F80769BD478052FB6533FA745D25EA5FB180@SC-VEXCH4.marvell.com>
In-Reply-To: <F766E4F80769BD478052FB6533FA745D25EA5FB180@SC-VEXCH4.marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/9/12 2:30 AM, Xiangliang Yu wrote:
> Agree with James, and just need to do NOT operation one time

Thanks for reviewing the patches.

Okay I'll remove patch 2 in v2 then.

> About patch 3, I check the ffz code and found it will check ~0 conditions.

Can you point me to the ~0 check in ffz code?  I also feel like using
__ffs64 makes the code simpler.

Does patch 1 look good to you?  Thanks.

- xi
