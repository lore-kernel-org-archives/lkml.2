Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab2HVFZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:25:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48787 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2HVFZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:25:33 -0400
MIME-Version: 1.0
In-Reply-To: <1345608994.1895.73.camel@vkoul-udesk3>
References: <1344069330-29569-1-git-send-email-Julia.Lawall@lip6.fr> <1345608994.1895.73.camel@vkoul-udesk3>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Aug 2012 13:25:11 +0800
Message-ID: <CAGsJ_4yjzE3eNGz=AA7gGxGNkjBH8bKRAUsYXcG+A1p8PtOQPw@mail.gmail.com>
Subject: Re: [PATCH] drivers/dma/sirf-dma.c: fix usage of devm functions
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Dan Williams <dan.j.williams@intel.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Barry Song <baohua.song@csr.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/22 Vinod Koul <vinod.koul@linux.intel.com>:
> On Sat, 2012-08-04 at 10:35 +0200, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Fix some problems with the use of devm_ functions.
> Applied, thanks

the git log "drivers/dma/sirf-dma.c: fix usage of devm functions"
should be fixed.

>
>
> --
> ~Vinod
>

-barry
