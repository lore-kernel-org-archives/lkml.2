Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab1FWET4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 00:19:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52580 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1FWET4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 00:19:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E02BEDB.2020103@jp.fujitsu.com>
Date: Thu, 23 Jun 2011 13:19:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: randy.dunlap@oracle.com
CC: fweisbec@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tshibata@ab.jp.nec.com, leoli@freescale.com
Subject: Re: [PATCH 4/4] sched: Generalize sleep inside spinlock detection
References: <1307712622-11104-1-git-send-email-fweisbec@gmail.com> <1307712622-11104-5-git-send-email-fweisbec@gmail.com> <4DF23A57.4030104@oracle.com>
In-Reply-To: <4DF23A57.4030104@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>>  There are quite a few other debugging options, some of which will be
>> diff --git a/Documentation/ja_JP/SubmitChecklist b/Documentation/ja_JP/SubmitChecklist
>> index 2df4576..cb5507b 100644
>> --- a/Documentation/ja_JP/SubmitChecklist
>> +++ b/Documentation/ja_JP/SubmitChecklist
>> @@ -68,7 +68,7 @@ Linux カーネルパッチ投稿者向けチェックリスト
>>  
>>  12: CONFIG_PREEMPT, CONFIG_DEBUG_PREEMPT, CONFIG_DEBUG_SLAB,
>>      CONFIG_DEBUG_PAGEALLOC, CONFIG_DEBUG_MUTEXES, CONFIG_DEBUG_SPINLOCK,
>> -    CONFIG_DEBUG_SPINLOCK_SLEEP これら全てを同時に有効にして動作確認を
>> +    CONFIG_DEBUG_ATOMIC_SLEEP これら全てを同時に有効にして動作確認を
>>      行ってください。

This Japanese part looks correct to me. :)



