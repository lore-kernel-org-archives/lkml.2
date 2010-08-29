Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab0H2L1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 07:27:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:51503 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0H2L1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 07:27:54 -0400
Message-ID: <4C7A42AA.1000806@kernel.org>
Date: Sun, 29 Aug 2010 13:21:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <633505726.1479321283081093502.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <633505726.1479321283081093502.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 29 Aug 2010 11:27:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/29/2010 01:24 PM, CAI Qian wrote:
>> On 08/29/2010 09:01 AM, caiqian@redhat.com wrote:
>>> Further bisect indicated this bad commit from the merge. Given kdump
>>> kernel was running with maxcpus=1, I guess this work caused fs/bio.c
>>> hung in the workqueue on UP. Reverted the whole merge let kdump work
>>> again.
>>
>> Can you please pull from the following git tree and see whether it
>> fixes the problem?  There was a bug in nr_active accounting.
>
> It had the same problem.

I see.  Hmm... a different issue then.  Can you please tell me how to
reproduce the problem?

Thanks.

-- 
tejun
