Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2I0FFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:05:22 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:45597 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab2I0FFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAG17yqQbRMaaEFyTBngMwdiKVBsGaOit1ufv3t5TdwLBgSKmfw@mail.gmail.com>
References: <1348563456-30569-1-git-send-email-inderpal.singh@linaro.org>
	<1348563456-30569-4-git-send-email-inderpal.singh@linaro.org>
	<CABb+yY3TcVr=0Po0N7TLCkQ9TmMJuvQhKJj3aQ1bP9+68T+Ogw@mail.gmail.com>
	<CAG17yqSOWhg_4KrQNojdYcpygkznvrzO74qnh8yasK=UH1f05Q@mail.gmail.com>
	<CABb+yY36pQ7oXC1OKEQ-1V55c2SZurcTAPaZ=_PWugqxdL2rgg@mail.gmail.com>
	<CAG17yqQ5NDr4sLvWbA85q5y079j2M2OV-uRjXSSL=OFPfCw3Zg@mail.gmail.com>
	<CABb+yY0dvtOZoa=T+gyTeWy3XyAictXJnqSkbF39E=peHSXDuQ@mail.gmail.com>
	<CAG17yqQbRMaaEFyTBngMwdiKVBsGaOit1ufv3t5TdwLBgSKmfw@mail.gmail.com>
Date: Thu, 27 Sep 2012 10:35:20 +0530
Message-ID: <CABb+yY0YAkaKaFRO14wYR52-Si5S=qfVczXs_2Z+jZYEpXFh2Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] DMA: PL330: Balance module remove function with probe
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Inderpal Singh <inderpal.singh@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        boojin.kim@samsung.com, vinod.koul@intel.com, patches@linaro.org,
        kgene.kim@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 9:43 AM, Inderpal Singh
<inderpal.singh@linaro.org> wrote:
>
> Don't you think free_chan_resource should be done __only if__
> alloc_chan_resource was successful ?
>
No, I don't think so. Thanks.
