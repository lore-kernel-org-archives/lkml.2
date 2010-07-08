Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab0GHE2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:28:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52902 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715Ab0GHE2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:28:43 -0400
Message-ID: <4C3553E2.7020607@redhat.com>
Date: Thu, 08 Jul 2010 00:28:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: Re: [PATCH v4 11/12] Let host know whether the guest can handle async
 PF in non-userspace context.
References: <1278433500-29884-1-git-send-email-gleb@redhat.com> <1278433500-29884-12-git-send-email-gleb@redhat.com>
In-Reply-To: <1278433500-29884-12-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 12:24 PM, Gleb Natapov wrote:
> If guest can detect that it runs in non-preemptable context it can
> handle async PFs at any time, so let host know that it can send async
> PF even if guest cpu is not in userspace.

The code looks correct.  One question though - is there a
reason to implement the userspace-only async PF path at
all, since the handling of async PF in non-userspace context
is introduced simultaneously?

> Signed-off-by: Gleb Natapov<gleb@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
