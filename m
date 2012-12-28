Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2L1A0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 19:26:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41074 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab2L1A0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 19:26:07 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <50DCE6D5.7000901@jp.fujitsu.com>
Date: Fri, 28 Dec 2012 09:24:53 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Arun Sharma <asharma@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, David Rientjes <rientjes@google.com>,
        John Stultz <john.stultz@linaro.org>, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [RFC v4 0/3] Support volatile for anonymous range
References: <1355813274-571-1-git-send-email-minchan@kernel.org> <50DA62CE.30604@jp.fujitsu.com> <20121226034600.GB2453@blaptop>
In-Reply-To: <20121226034600.GB2453@blaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/12/26 12:46), Minchan Kim wrote:
> Hi Kame,
>
> What are you doing these holiday season? :)
> I can't believe you sit down in front of computer.
>
Honestly, my holiday starts tomorrow ;) (but until 1/5 in the next year.)

>>
>> Hm, by the way, the user need to attach pages to the process by causing page-fault
>> (as you do by memset()) before calling mvolatile() ?
>
> For effectiveness, Yes.
>

Isn't it better to make page-fault by get_user_pages() in mvolatile() ?
Calling page fault in userland seems just to increase burden of apps.

>>
>> I think your approach is interesting, anyway.
>
> Thanks for your interest, Kame.
>
> あけましておめでとう.
>

A happy new year.

Thanks,
-Kame


