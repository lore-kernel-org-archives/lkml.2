Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab1FQPLx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 11:11:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41079 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210Ab1FQPLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 11:11:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Milton Miller <miltonm@bga.com>, Jens Axboe <axboe@kernel.dk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>, WANG Cong <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] generic-ipi: Initialize call_single_queue before enabling interrupt
Date: Fri, 17 Jun 2011 11:11:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Mailer: HidemaruMail 5.38 (WinNT,501)
In-Reply-To: <20110617081911.GB893@elte.hu>
References: <D6CBEE2F420741indou.takao@jp.fujitsu.com> <ABCC2C38C9CAC4indou.takao@jp.fujitsu.com> <20110617081911.GB893@elte.hu>
Message-Id: <ACCC2D00C516DAindou.takao@jp.fujitsu.com>
X-Antivirus: avast! (VPS 110617-0, 2011/06/17), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 10:19:11 +0200, Ingo Molnar wrote:

>
>* Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
>
>> Just a reminder...
>> 
>> Thanks for acks, but I'm still waiting for inclusion.
>> I tested 3.0.0-rc3 and kdump still failed due to pending IPI
>> from 1st kernel. Need this patch to fix it.
>
>For any future patch that has a review discussion (like this one) 
>please collect Acks and resend the patch with the acks included once 
>the discussion results in a final patch, otherwise maintainers might 
>skip the patch as "still being reviewed".
>
>I've collected the acks here and started testing your patch.

Ok, understood. Thanks for your advice.

Thanks,
Takao Indoh


>
>Thanks,
>
>	Ingo
