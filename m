Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab2A2NRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 08:17:35 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59385 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2A2NRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 08:17:34 -0500
MIME-Version: 1.0
In-Reply-To: <1327705373-29395-2-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1327705373-29395-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1327705373-29395-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Sun, 29 Jan 2012 21:17:32 +0800
Message-ID: <CAJd=RBDLEWuAKmRcaUJXuz=h9_3kaexbdGyqv7KXn+dmMeUvCQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] pagemap: avoid splitting thp when reading /proc/pid/pagemap
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naoya

On Sat, Jan 28, 2012 at 7:02 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> Thp split is not necessary if we explicitly check whether pmds are
> mapping thps or not. This patch introduces this check and adds code
> to generate pagemap entries for pmds mapping thps, which results in
> less performance impact of pagemap on thp.
>

Could the method proposed here cover the two cases of split THP in mem cgroup?

Thanks
Hillf
