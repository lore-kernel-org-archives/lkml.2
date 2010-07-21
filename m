Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab0GUOy2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 10:54:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:41186 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab0GUOy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 10:54:27 -0400
Message-ID: <4C4709B6.6000207@kernel.org>
Date: Wed, 21 Jul 2010 16:52:38 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, arjan@linux.intel.com, oleg@redhat.com,
        axboe@kernel.dk, fweisbec@gmail.com, dwalker@codeaurora.org,
        stefanr@s5r6.in-berlin.de, florian@mickler.org, andi@firstfloor.org,
        mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCHSET] workqueue: concurrency managed workqueue, take#6
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <21756.1279718599@redhat.com>
In-Reply-To: <21756.1279718599@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 14:52:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2010 03:23 PM, David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
>> B. General documentation of Concurrency Managed Workqueue (cmwq)
>> ================================================================
> 
> This should be in Documentation/workqueue.txt or something like that.

Yeap, once things settle a bit.  I'll update it and put it under
documentatino.

Thanks.

-- 
tejun
