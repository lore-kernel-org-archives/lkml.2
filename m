Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335Ab1CWOXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 10:23:21 -0400
Received: from fifo99.com ([67.223.236.141]:49189 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab1CWOXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 10:23:19 -0400
Subject: Re: [Git pull] MSM for v2.6.39
From: Daniel Walker <dwalker@fifo99.com>
To: David Brown <davidb@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bryan Huntsman <bryanh@codeaurora.org>
In-Reply-To: <8yazkotpwk6.fsf@huya.qualcomm.com>
References: <8yazkotpwk6.fsf@huya.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 07:23:11 -0700
Message-ID: <1300890191.6117.43.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-17 at 08:59 -0700, David Brown wrote:
> David Brown (16):
>       msm: Add CPU queries
>       msm: Generalize timer register mappings
>       msm: Generalize QGIC registers
>       msm: Add MSM 8960 cpu_is check
>       Merge branch 'msm-uart' into for-next
>       Merge branch 'msm-8960' into for-next
>       Merge branch 'msm-sdcc' into for-next
>       Merge branch 'msm-fb' into for-next
>       Merge branch 'msm-8960' into msm-core
>       msm: Remove broken register definition from trout
>       msm: Warning fix in trout gpio board file
>       Merge branch 'msm-core' into for-next
>       Merge branch 'msm-core' into for-next
>       Merge branch 'msm-core' into for-next
>       msm: Use explicit GPLv2 licenses
>       Merge remote branch 'rmk/for-linus' into for-linus 

Could you change the "for-next" name to something more interesting like
msm-for-linus .. I think it would be acceptable to just create
msm-for-linus during the merge window and merge all the sub-tree's into
that.

Daniel

