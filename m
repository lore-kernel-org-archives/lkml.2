Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1KVFkO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:40:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab1KVFkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:40:12 -0500
Message-ID: <4ECB35A7.9050709@redhat.com>
Date: Tue, 22 Nov 2011 13:39:51 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Pekka Enberg <penberg@kernel.org>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
References: <1321612791-4764-1-git-send-email-amwang@redhat.com> <20111119100326.GA27967@infradead.org> <CAPXgP10q8Fba3vr0zf-XBBaRPwjP7MyJ=-QRL45_8WC-vtotOg@mail.gmail.com> <20111121100622.GA17887@infradead.org>
In-Reply-To: <20111121100622.GA17887@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月21日 18:06, Christoph Hellwig 写道:
> On Sat, Nov 19, 2011 at 03:14:48PM +0100, Kay Sievers wrote:
>> On Sat, Nov 19, 2011 at 11:03, Christoph Hellwig<hch@infradead.org>  wrote:
>>> On Fri, Nov 18, 2011 at 06:39:50PM +0800, Cong Wang wrote:
>>>> It seems that systemd needs tmpfs to support fallocate,
>>>> see http://lkml.org/lkml/2011/10/20/275. This patch adds
>>>> fallocate support to tmpfs.
>>>
>>> What for exactly? ??Please explain why preallocating on tmpfs would
>>> make any sense.
>>
>> To be able to safely use mmap(), regarding SIGBUS, on files on the
>> /dev/shm filesystem. The glibc fallback loop for -ENOSYS on fallocate
>> is just ugly.
>
> That is the kind of information which needs to be in the changelog.
>

I will fix the changelog.

Thanks, Christoph and Kay.
