Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1EZTCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:02:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753300Ab1EZTCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:02:34 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTikgXhmgzQYfSWKDoxVyNuCzSM7Qxw@mail.gmail.com>
References: <4DDE2873.7060409@jp.fujitsu.com> <BANLkTi=znC18PAbpDfeVO+=Pat_EeXddjw@mail.gmail.com>
 <BANLkTikgXhmgzQYfSWKDoxVyNuCzSM7Qxw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 26 May 2011 12:01:44 -0700
Message-ID: <BANLkTin3vHzUu-p654jvkG4R1Td261b3Aw@mail.gmail.com>
Subject: Re: [PATCH] mm: don't access vm_flags as 'int'
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, benh@kernel.crashing.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org, dave@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 11:50 AM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
>
> This breaks kernel builds with CONFIG_HUGETLBFS=n. :-(

Grr. I did the "allyesconfig" build to find any problems, but that
obviously also sets HUGETLBFS.

But "allnoconfig" does find this.

                  Linus
