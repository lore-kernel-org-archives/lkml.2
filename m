Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab2BTLyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:54:37 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40196 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab2BTLyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:54:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.37.68 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F423478.5060506@suse.cz>
Date: Mon, 20 Feb 2012 12:54:32 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
References: <1329722927-12108-1-git-send-email-n-horiguchi@ah.jp.nec.com> <alpine.LSU.2.00.1202200329420.4225@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1202200329420.4225@eggly.anvils>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 12:38 PM, Hugh Dickins wrote:
> That fixes the case I hit, thank you.  Though I did have to apply
> the task_mmu.c part by hand, there are differences on neighbouring
> lines.

The same here.

> Jiri, your "Regression: Bad page map in process xyz" is actually
> on linux-next, isn't it?  I wonder if this patch will fix yours too
> (you were using zypper, I was updating with yast2).

Yes, it does. Thanks.

-- 
js
suse labs
