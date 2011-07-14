Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1GNQrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 12:47:09 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:56579 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab1GNQrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 12:47:07 -0400
Message-ID: <4E1F1D7F.50904@cs.tu-berlin.de>
Date: Thu, 14 Jul 2011 18:46:55 +0200
From: =?UTF-8?B?SmFuIFNjaMO2bmhlcnI=?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110711 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] sched: Use leaf_cfs_rqs in load_balance_fair()
References: <1310580816-10861-1-git-send-email-schnhrr@cs.tu-berlin.de>	 <1310580816-10861-6-git-send-email-schnhrr@cs.tu-berlin.de> <1310589866.2586.31.camel@twins>
In-Reply-To: <1310589866.2586.31.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 13.07.2011 22:44, schrieb Peter Zijlstra:
> On Wed, 2011-07-13 at 20:13 +0200, Jan H. Schönherr wrote:
>> Since commit 3d4b47b4 ("sched: Implement on-demand (active) cfs_rq list")
>> the leaf_cfs_rqs provide an advantage over the task_group list.
>>
>> Make use of it in load_balance_fair(), so that we do not unnecessarily
>> iterate over empty cfs_rqs where we cannot pull anything from.
> 
> I just send a similar patch today:
> 
> https://lkml.org/lkml/2011/7/13/94

Yes. I've seen that too late.

Sorry for the noise.

Regards
Jan


