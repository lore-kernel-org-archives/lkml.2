Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab0JPCCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 22:02:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39529 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752230Ab0JPCC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 22:02:29 -0400
X-User-Agent: K-9 Mail for Android
References: <tip-77dff1c755c3218691e95e7e38ee14323b35dbdb@git.kernel.org> <4CB8EE8A.5020900@goop.org> <4CB8EF30.7060504@goop.org>
In-Reply-To: <4CB8EF30.7060504@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Xen-devel] Re: [tip:irq/core] x86: xen: Sanitise sparse_irq handling
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 15 Oct 2010 19:01:36 -0700
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Message-ID: <6a6702dc-7dbb-47a3-a0cf-18c8a65252fe@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should.

"Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> On 10/15/2010 05:15 PM, Jeremy Fitzhardinge wrote:
>>  On 10/12/2010 01:29 PM, tip-bot for Thomas Gleixner wrote:
>>> Commit-ID:  77dff1c755c3218691e95e7e38ee14323b35dbdb
>>> Gitweb:     http://git.kernel.org/tip/77dff1c755c3218691e95e7e38ee14323b35dbdb
>>> Author:     Thomas Gleixner <tglx@linutronix.de>
>>> AuthorDate: Wed, 29 Sep 2010 17:37:10 +0200
>>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>>> CommitDate: Tue, 12 Oct 2010 16:53:44 +0200
>>>
>>> x86: xen: Sanitise sparse_irq handling
>>>
>>> There seems to be more cleanups possible, but that's left to the xen
>>> experts :)
>> This causes the kernel to fail to boot under Xen.  The WARN_ON(res !=
>> irq) triggers and nobody is very happy about the results.
>
>Of course the really interesting question is whether this sparse irq
>rework allows us to hang our extra per-irq information of the irq_data
>structure now, rather than having to maintain all these auxiliary arrays?
>
>Thanks,
>    J

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
