Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab1ERACx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:02:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49101 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab1ERACw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:02:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD30C9E.8010200@jp.fujitsu.com>
Date: Wed, 18 May 2011 09:02:38 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: wilsons@start.ca
CC: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, hughd@google.com, rientjes@google.com,
        lee.schermerhorn@hp.com, adobriyan@gmail.com, cl@linux-foundation.org
Subject: Re: [PATCH v2 7/9] mm: proc: move show_numa_map() to fs/proc/task_mmu.c
References: <1305498029-11677-1-git-send-email-wilsons@start.ca> <1305498029-11677-8-git-send-email-wilsons@start.ca>
In-Reply-To: <1305498029-11677-8-git-send-email-wilsons@start.ca>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/16 7:20), Stephen Wilson wrote:
> Moving show_numa_map() from mempolicy.c to task_mmu.c solves several
> issues.
> 
>    - Having the show() operation "miles away" from the corresponding
>      seq_file iteration operations is a maintenance burden.
> 
>    - The need to export ad hoc info like struct proc_maps_private is
>      eliminated.
> 
>    - The implementation of show_numa_map() can be improved in a simple
>      manner by cooperating with the other seq_file operations (start,
>      stop, etc) -- something that would be messy to do without this
>      change.
> 
> Signed-off-by: Stephen Wilson<wilsons@start.ca>
> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Cc: Hugh Dickins<hughd@google.com>
> Cc: David Rientjes<rientjes@google.com>
> Cc: Lee Schermerhorn<lee.schermerhorn@hp.com>
> Cc: Alexey Dobriyan<adobriyan@gmail.com>
> Cc: Christoph Lameter<cl@linux-foundation.org>

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



