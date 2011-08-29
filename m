Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab1H2OPS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:15:18 -0400
Received: from mail.ss.pku.edu.cn ([211.101.48.138]:37319 "EHLO
	mail.ss.pku.edu.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1H2OPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com>
References: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com>
	<alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com>
Date: Mon, 29 Aug 2011 22:15:07 +0800
Message-ID: <CAF1ivSY0NwdZTCQQ_BG5Vk8rnjiH=sS0V08ajxc8Gw5YBwD3qA@mail.gmail.com>
Subject: Re: blkdev_issue_discard() hangs forever if the underlying storage
 device is removed
From: Lin Ming <lxy@ss.pku.edu.cn>
To: Lukas Czerner <lczerner@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 7:56 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>
> Regarding the atomic operations I do not think that implicit memory
> barriers are needed here as atomic_dec_and_test() implies memory

Which implicit memory barrier you are talking about?

> barrier, atomic_set() is out of the scope of our interest (and it would
> not cause the problem like that anyway) and reordering atomic_inc()
> would not cause problem like this as well.
