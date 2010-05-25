Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab0EYFbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 01:31:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754746Ab0EYFbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 01:31:24 -0400
Message-ID: <4BFB6197.5030206@redhat.com>
Date: Tue, 25 May 2010 13:35:19 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
CC: opurdila@ixiacom.com, davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: proc_dointvec() and write
References: <306.1274711539@jrobl> <4BFB56F1.1080200@redhat.com> <11729.1274763460@jrobl>
In-Reply-To: <11729.1274763460@jrobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/10 12:57, J. R. Okajima wrote:
> Cong Wang:
>> Hmm, odd, I tested other proc files, I see no problem.
>> I am wondering why /proc/sys/kernel/printk is special here.
>
> The condition is,
> - the entry has multiple values, .maxlen = N * sizeof(foo)
> - the entry is writable, .mode = 0644 (or something)
>
> In sysctl.c, only "printk" and "acct" match.

Hmm, right, I missed this case during testing.

Your patch looks correct for me. Would you mind to send your
patch again with your Signed-off-by?

Thank you!
