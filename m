Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0FNWTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:19:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:58870 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0FNWTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:19:08 -0400
Message-ID: <4C16AA75.8030303@kernel.org>
Date: Tue, 15 Jun 2010 00:17:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, johannes@sipsolutions.net,
       oleg@redhat.com, axboe@kernel.dk
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#5
References: <1276551467-21246-1-git-send-email-tj@kernel.org> <20100614145839.8ac7687a.akpm@linux-foundation.org>
In-Reply-To: <20100614145839.8ac7687a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 22:17:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 11:58 PM, Andrew Morton wrote:
> On Mon, 14 Jun 2010 23:37:17 +0200
> Tejun Heo <tj@kernel.org> wrote:
> 
>> This is the fifth take of cmwq (concurrency managed workqueue)
>> patchset.
> 
> What is a concurrency managed workqueue and why do we want one?

That goes back about 9 month.  You were cc'd there too.  :-)

  http://thread.gmane.org/gmane.linux.kernel/896268

Thanks.

-- 
tejun
