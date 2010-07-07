Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab0GGWqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 18:46:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab0GGWqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 18:46:16 -0400
Message-ID: <4C350398.5070504@redhat.com>
Date: Wed, 07 Jul 2010 18:45:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       avi@redhat.com, mingo@elte.hu, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, hpa@zytor.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: Re: [PATCH v4 05/12] Export __get_user_pages_fast.
References: <1278433500-29884-1-git-send-email-gleb@redhat.com> <1278433500-29884-6-git-send-email-gleb@redhat.com>
In-Reply-To: <1278433500-29884-6-git-send-email-gleb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2010 12:24 PM, Gleb Natapov wrote:
> KVM will use it to try and find a page without falling back to slow
> gup. That is why get_user_pages_fast() is not enough.
>
> Signed-off-by: Gleb Natapov<gleb@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
