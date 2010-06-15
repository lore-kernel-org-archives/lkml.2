Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0FOU34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 16:29:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55041 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0FOU3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 16:29:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C17E28D.9000805@s5r6.in-berlin.de>
Date: Tue, 15 Jun 2010 22:29:01 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100415 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <4C17C671.3020605@s5r6.in-berlin.de>
In-Reply-To: <4C17C671.3020605@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> As a driver maintainer, I would find it helpful if the WQ_flags in
> include/linux/workqueue.h and/or __create_workqueue_key() in
> kernel/workqueue.c (or its wrappers in include/linux/workqueue.h) were
> better documented.

On second thought, and having read your other posts of today, I take
this mostly back.  It seems that a great deal of what driver writers
need is provided by one of your three system workqueues, and these are
IMO fully well documented.  Thanks Tejun.
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/
