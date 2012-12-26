Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab2LZC5Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:57:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab2LZC5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:57:22 -0500
Message-ID: <50DA670C.4050704@redhat.com>
Date: Wed, 26 Dec 2012 10:55:08 +0800
From: Zhouping Liu <zliu@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        mgorman@suse.de, hughd@google.com,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: kernel BUG at mm/huge_memory.c:1798!
References: <1621091901.34838094.1356409676820.JavaMail.root@redhat.com> <535932623.34838584.1356410331076.JavaMail.root@redhat.com> <CAJd=RBB9Tqv9c_Wv+N8yJOftfkJeUS10vLuz14eoLH1eEtjmBQ@mail.gmail.com>
In-Reply-To: <CAJd=RBB9Tqv9c_Wv+N8yJOftfkJeUS10vLuz14eoLH1eEtjmBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 08:05 PM, Hillf Danton wrote:
> On Tue, Dec 25, 2012 at 12:38 PM, Zhouping Liu <zliu@redhat.com> wrote:
>> Hello all,
>>
>> I found the below kernel bug using latest mainline(637704cbc95),
>> my hardware has 2 numa nodes, and it's easy to reproduce the issue
>> using LTP test case: "# ./mmap10 -a -s -c 200":
> Can you test with 5a505085f0 and 4fc3f1d66b1 reverted?

Hello Hillf, I tested it with 5a505085f0 and 4fc3f1d66b1 reverted, you 
are right, the issue is gone.

Thanks,
Zhouping
