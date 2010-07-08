Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0GHEWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 00:22:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab0GHEWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 00:22:01 -0400
Message-ID: <4C35524E.70104@redhat.com>
Date: Thu, 08 Jul 2010 00:21:34 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: Re: [PATCH v4 09/12] Retry fault before vmentry
References: <1278433500-29884-1-git-send-email-gleb@redhat.com> <1278433500-29884-10-git-send-email-gleb@redhat.com>
In-Reply-To: <1278433500-29884-10-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 12:24 PM, Gleb Natapov wrote:
> When page is swapped in it is mapped into guest memory only after guest
> tries to access it again and generate another fault. To save this fault
> we can map it immediately since we know that guest is going to access
> the page.
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
