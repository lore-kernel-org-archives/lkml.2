Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab2CUB0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:26:47 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35289 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab2CUB0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:26:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120320163142.GF17071@redhat.com>
References: <4F62EE56.6000702@kernel.org>
	<20120320163142.GF17071@redhat.com>
Date: Wed, 21 Mar 2012 09:26:45 +0800
X-Google-Sender-Auth: CjcKBE4XSVbz5TIKMGCyQD2qlQY
Message-ID: <CANejiEUcBVOA9iSw6viVia-3jduYmO28FuH-TgDFicnsfKmNGQ@mail.gmail.com>
Subject: Re: [patch]blk: use correct sectors limitation for discard request
From: Shaohua Li <shli@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/21 Vivek Goyal <vgoyal@redhat.com>:
> On Fri, Mar 16, 2012 at 03:40:06PM +0800, Shaohua Li wrote:
>>
>> Subject: blk: use correct sectors limitation for discard request
>>
>> max_discard_sectors doesn't equal to max_sectors/max_hw_sectors.
>> Without this,
>> discard request merge might be ignored.
>
> In other patch you are making discard request non-mergeable. So what's
> the purpose of this patch.
Yep, this one has no effect with that patch. But this is a bug, and eventually
we will support discard merge. Just to make sure it doesn't slip away.
