Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933920Ab0FRR6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:58:50 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47920 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754832Ab0FRR6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:58:48 -0400
Message-ID: <4C1BB3D7.5060301@kernel.dk>
Date: Fri, 18 Jun 2010 19:58:47 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH] cfq-iosched: Fixed boot warning with BLK_CGROUP=y and
  CFQ_GROUP_IOSCHED=n
References: <20100618143947.GA8431@redhat.com>
In-Reply-To: <20100618143947.GA8431@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-18 16:39, Vivek Goyal wrote:
> Hi Jens,
> 
> Few days back Ingo noticed a CFQ boot time warning. This patch fixes it.
> The issue here is that with CFQ_GROUP_IOSCHED=n, CFQ should not really
> be making blkio stat related calls.

Thanks applied. Still hoping to eventually get a better variant done,
but at least this fixes the problemf or now.

-- 
Jens Axboe

