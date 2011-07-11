Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab1GKFoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 01:44:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62569 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab1GKFoH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 01:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <1309757789.15392.236.camel@sli10-conroe>
References: <1309757789.15392.236.camel@sli10-conroe>
Date: Mon, 11 Jul 2011 13:44:05 +0800
X-Google-Sender-Auth: _gesCx6gbK6Vrvvfjros1O-4BSE
Message-ID: <CANejiEXryM=hawNjQZPYEM2L97+gUYqHQ_YQJ5p5gLTvBkC25Q@mail.gmail.com>
Subject: Re: [PATCH 0/3]CFQ: add think time check for service tree and group
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/4 Shaohua Li <shaohua.li@intel.com>:
> Hi,
>  Currently when the last queue of a service tree/group is empty, CFQ
> doesn't expire the queue. This is to allow requests from the tree/group
> come soon, so tree/group doesn't miss its share. But if the think time
> is big, the assumption isn't correct. idling the queue is just wasting
> bandwidth.
>
> Originally I was hoping this can resolve Vivek's fsync issue, but it
> doesn't. The fsync issue is caused by queue idling. But since think time
> check only helps for think time above default queue idle time (8ms),
> think time check doesn't help.
>
> On the other hand, think time check is still helpful for queues with
> think time. I had test case in follow patches show throughput
> improvement without sacrifice tree/group shares.
>
Jens,
can you look at the patches? I refreshed some patches in replying
Vivek, I can resend if required.

Thanks,
Shaohua
