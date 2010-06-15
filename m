Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab0FOQiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 12:38:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:54187 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756970Ab0FOQiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 12:38:24 -0400
Message-ID: <4C17AC47.1080808@kernel.org>
Date: Tue, 15 Jun 2010 18:37:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH 08/30] workqueue: temporarily disable workqueue tracing
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <1276551467-21246-9-git-send-email-tj@kernel.org> <20100615132926.GE5342@nowhere>
In-Reply-To: <20100615132926.GE5342@nowhere>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Jun 2010 16:37:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 03:29 PM, Frederic Weisbecker wrote:
> On Mon, Jun 14, 2010 at 11:37:25PM +0200, Tejun Heo wrote:
>> Strip tracing code from workqueue and disable workqueue tracing.  This
>> is temporary measure till concurrency managed workqueue is complete.
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> ---
>>  kernel/trace/Kconfig |    4 +++-
>>  kernel/workqueue.c   |   14 +++-----------
>>  2 files changed, 6 insertions(+), 12 deletions(-)
> 
> If the new workqueue implementation makes the workqueue tracing useless,
> than please remove it. We can think about providing a more suitable
> tracing for that later, once we have determined the interesting organic
> points.
> 
> I'll be happy to help.

Cool, yeah, will rip it out.

Thanks.

-- 
tejun
