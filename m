Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0JEBW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 21:22:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806Ab0JEBW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 21:22:26 -0400
Message-ID: <4CAA7D7B.5000504@redhat.com>
Date: Mon, 04 Oct 2010 21:20:59 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
        mtosatti@redhat.com
Subject: Re: [PATCH v6 02/12] Halt vcpu if page it tries to access is swapped
 out.
References: <1286207794-16120-1-git-send-email-gleb@redhat.com> <1286207794-16120-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1286207794-16120-3-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 11:56 AM, Gleb Natapov wrote:
> If a guest accesses swapped out memory do not swap it in from vcpu thread
> context. Schedule work to do swapping and put vcpu into halted state
> instead.
>
> Interrupts will still be delivered to the guest and if interrupt will
> cause reschedule guest will continue to run another task.
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>

This seems quite different from the last version, but it
looks fine to me.

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
