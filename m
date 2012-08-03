Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2HCCKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 22:10:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56175 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2HCCKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 22:10:35 -0400
MIME-Version: 1.0
In-Reply-To: <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	<4F69C62C.7020604@kernel.org>
	<yq18vitwejt.fsf@sermon.lab.mkp.net>
	<CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
	<yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
	<20120620085724.GA26295@infradead.org>
	<yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
Date: Fri, 3 Aug 2012 10:10:34 +0800
X-Google-Sender-Auth: 64SxcSz3b9aW2cZKAICu525fnlo
Message-ID: <CANejiEVBMmt_tdtuzEWtGCJZpiWfsuNto-g03ZfRSacWh6PJ=w@mail.gmail.com>
Subject: Re: [patch 1/2]block: handle merged discard request
From: Shaohua Li <shli@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Vivek Goyal <vgoyal@redhat.com>,
        axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/22 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
>
>>> There are several additional commands in the pipeline where the 1:1
>>> mapping between DMA size and block range is invalid. I want to get
>>> rid of the 1:1 assumption in general so we can handle any command
>>> without these evil workarounds.
>
> Christoph> What's the progress on getting these issues sorted out?
>
> This has bitrotted for a while. I'll put it on my list. I should finally
> have some bandwidth again next week...

Any update on this? If this will not happen soon, should we just disable
discard request merge now?

Thanks,
Shaohua
