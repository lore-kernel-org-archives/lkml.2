Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2HNHXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 03:23:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35810 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753978Ab2HNHXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 03:23:16 -0400
MIME-Version: 1.0
In-Reply-To: <5029F8F6.1080207@samsung.com>
References: <5029F8F6.1080207@samsung.com>
Date: Tue, 14 Aug 2012 16:23:15 +0900
Message-ID: <CAKYAXd86V59ffWG05-g5VuE_PHOsbfstNrpYAdM9+69jZHJXAQ@mail.gmail.com>
Subject: Re: [PATCH v3] mmc: card: Skip secure option for MoviNAND.
From: Namjae Jeon <linkinjeon@gmail.com>
To: IAN CHEN <ian.cy.chen@samsung.com>
Cc: cjb@laptop.org, adrian.hunter@intel.com, subhashj@codeaurora.org,
        linus.walleij@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, d.j.shin@samsung.com,
        jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/14, IAN CHEN <ian.cy.chen@samsung.com>:
> For several MoviNAND, there are some known issue with secure option.
> For these specific MoviNAND device, we skip secure option.
>
> You could refer this discussion in XDA developers.
> http://forum.xda-developers.com/showthread.php?t=1644364
> https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184813224730/posts/21pTYfTsCkB
>
> Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
> ---
Looks good.
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
