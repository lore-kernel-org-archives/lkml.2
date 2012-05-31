Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247Ab2EaKwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 06:52:04 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65033 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2EaKwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 06:52:01 -0400
Subject: Re: [PATCH] block: avoid infinite loop in get_task_io_context()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4FC74C59.2030100@fusionio.com>
References: <4FC6189B.9080909@fusionio.com>
	 <1338402812.2760.413.camel@edumazet-glaptop>
	 <4FC66D3D.6080509@fusionio.com>
	 <1338404902.2760.451.camel@edumazet-glaptop>
	 <1338410107.2760.544.camel@edumazet-glaptop>
	 <1338460706.2760.1330.camel@edumazet-glaptop>
	 <4FC74C59.2030100@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 May 2012 12:51:56 +0200
Message-ID: <1338461516.2760.1333.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 12:47 +0200, Jens Axboe wrote:
>  BUG: soft lockup - CPU#3 stuck for 22s ! [mountall.1603]
> 
> Eric, do you have a task trace to go with this lockup, where task !=
> current?
> 
> In any case, it is a legit bug fix. I have applied it.
> 

Unfortunately I couldn't get netconsole working at this stage...

syscall was sys_ioprio_set()



