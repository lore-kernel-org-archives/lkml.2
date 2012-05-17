Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967422Ab2EQQti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:49:38 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:20143 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S966239Ab2EQQth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:49:37 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 3Gr8KYoVM1lOCPjYniiwveBPxh67R_6KwXD0vWphgQ7SYrS
 J78PEiO9m4YG8AS89BRDnbkJnjOHZhPGxzaSenOV37l2jDCWkllyP8sORYFG
 XtoNkuzRSl5g23RFhiKXpp7y2xX_ju9yHRCutYLQXf4HSirufnAweQrp0hbq
 ceTwKL2t3o6B_ubZO7Nc8NQBSGLxF8WLF5o2aamPsgVkoiRtqiCLlM_VmOfI
 yrvRs1jXj7zLJVkCii3e4xPxpVBUUQp5u3ZkLQHZzC3mN61wtw5T_iiBypT4
 VwzqhzWYqwFLEnFeF_9FehheT5MJHq7pvPshPmyMOd.mdv3HlBPFkCPqHv.i
 K4kxEB9rLpbZPrIQSYYYw0EI.GVHK3su997AouyEyO_E7wctIIYMP7we.DFN
 L
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 17 May 2012 11:49:34 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Joonsoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1,2/4 v2] slub: use __cmpxchg_double_slab() at interrupt
 disabled place
In-Reply-To: <1337272864-5090-1-git-send-email-js1304@gmail.com>
Message-ID: <alpine.DEB.2.00.1205171149050.8534@router.home>
References: <1337269668-4619-1-git-send-email-js1304@gmail.com> <1337272864-5090-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012, Joonsoo Kim wrote:

> get_freelist() is only called by __slab_alloc() with interrupt disabled,
> so __cmpxchg_double_slab() is suitable.
>
> unfreeze_partials() is only called with interrupt disabled,
> so __cmpxchg_double_slab() is suitable.

Combine these sentences as well.

Acked-by: Christoph Lameter <cl@linux.com>

