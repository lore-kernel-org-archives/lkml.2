Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab0GGWn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756350Ab0GGWn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:43:56 -0400
Message-ID: <4C3501ED.7040805@redhat.com>
Date: Wed, 07 Jul 2010 18:38:37 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: Re: [PATCH v4 04/12] Provide special async page fault handler when
 async PF capability is detected
References: <1278433500-29884-1-git-send-email-gleb@redhat.com> <1278433500-29884-5-git-send-email-gleb@redhat.com>
In-Reply-To: <1278433500-29884-5-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 12:24 PM, Gleb Natapov wrote:
> When async PF capability is detected hook up special page fault handler
> that will handle async page fault events and bypass other page faults to
> regular page fault handler.
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>

I had some concerns with this patch, but it looks like patch
10/12 addresses all of those, so ...

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
