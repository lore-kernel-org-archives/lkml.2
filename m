Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2JIPZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:25:50 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:64696 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756102Ab2JIPZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <507371DA.9080309@samsung.com>
References: <CAH+eYFCJTtF+FeqKs_ho5yyX0tkUBoaa-yfsd1rVshcQ5Xxp=A@mail.gmail.com>
 <507371DA.9080309@samsung.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 9 Oct 2012 17:25:03 +0200
X-Google-Sender-Auth: WE7hnNT_73RPQUYNUIwN1BQPHJg
Message-ID: <CAH+eYFDK=C4=e5D00=TM=rv+zzE1rEuQ_=97A5T0z6pORTLMpA@mail.gmail.com>
Subject: Re: CMA and zone watermarks
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek, Minchan,

2012/10/9 Marek Szyprowski <m.szyprowski@samsung.com>:
> Could You run your test with latest linux-next kernel? There have been some
> patches merged to akpm tree which should fix accounting for free and free
> cma pages. I hope it should fix this issue.

I've tested with the mentioned patches (which seem to have also reached
Linus' tree today) and they appear to resolve the problem.

Thanks.
