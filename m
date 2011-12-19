Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1LSUsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:48:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42138 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1LSUsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:48:05 -0500
Message-ID: <4EEFA308.2090608@gmail.com>
Date: Mon, 19 Dec 2011 15:48:08 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/3] pagemap: export KPF_THP
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com> <4EEF8F85.9010408@gmail.com> <4EEF9E04.1040007@ah.jp.nec.com>
In-Reply-To: <4EEF9E04.1040007@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The detail of transparent hugepage are hidden by design. We hope it
>> keep 'transparent'.
>> Until any explain why we should expose KPF_THP, we don't agree it.
> 
> The reason why I want to know physical address of thp is testing.
> I'm working on memory error recovery and writing test code to confirm
> that memory recovery really works when an error occurs on thps.
> There I need to locate thps on the physical memory.

I'm sorry, I simply don't understand what you say. Why do you think
memory recovery and thp are related feature?



> 
> IMO, transparency in thp means that we need no manual setup to use
> it (as a contrast with hugetlbfs,) so it seems to me that exporting
> pageflag of thp does not break the design of thp.
> 
> Anyway, I should have written the purpose in the patch description.
> Thanks for the comment.
> 
> Naoya

