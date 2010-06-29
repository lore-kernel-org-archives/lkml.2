Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0F2HFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 03:05:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39118 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363Ab0F2HFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 03:05:52 -0400
Message-ID: <4C299A2B.604@kernel.org>
Date: Tue, 29 Jun 2010 09:00:59 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 33/35] libata: take advantage of cmwq and remove concurrency
 limitations
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-34-git-send-email-tj@kernel.org> <4C292308.4050906@pobox.com>
In-Reply-To: <4C292308.4050906@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 07:01:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 12:32 AM, Jeff Garzik wrote:
>> Signed-off-by: Tejun Heo<tj@kernel.org>
>> Cc: Jeff Garzik<jgarzik@pobox.com>
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>

Thanks, Jeff.

-- 
tejun
