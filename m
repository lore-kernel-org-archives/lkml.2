Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946215Ab2EKV0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 17:26:43 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:52721 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695Ab2EKV0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 17:26:42 -0400
Message-ID: <4FAD840D.9020009@gmail.com>
Date: Fri, 11 May 2012 17:26:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
CC: linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com,
        frank.rowand@am.sony.com, tim.bird@am.sony.com,
        takuzo.ohara@ap.sony.com, kan.iibuchi@jp.sony.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][PATCH] mm: Update zone->un_reclaimable in direct reclaim
 path
References: <CAEtiSau7w+aUf_pK39JS+-SgRRqHav4b1UZMiNFHCJTNPfN7EQ@mail.gmail.com>
In-Reply-To: <CAEtiSau7w+aUf_pK39JS+-SgRRqHav4b1UZMiNFHCJTNPfN7EQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/11/12 4:35 AM), Aaditya Kumar wrote:
> Dear All,
>
>   Commit 929bea7c714220fc76ce3f75bef9056477c28e74 seems to have broken the
>   OOM invocation during memory hot unplug in low memory conditions. This commit
>   modifies the 'un-reclaimabilty check'  for  giving up trying to
> reclaim pages in the
> direct reclaim path and invoke OOM  killer to be based on zone->unreclaimable.

Today I don't have a time and I didn't read your patch. but I would say my patch
passed my hotplug test. so can you please tell us your test case and reproducer?

I'll look into closely later.



