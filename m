Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab2L1TQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:16:40 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:51679 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2L1TQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:16:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAAmzW4MhCyYkdpOaHnJtoMoJeFsXQJXN=Cpo3s67=s+id-hrMg@mail.gmail.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com>
	<1356293711-23864-2-git-send-email-sasha.levin@oracle.com>
	<alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com>
	<50DCCE5A.4000805@oracle.com>
	<alpine.DEB.2.00.1212271502070.23127@chino.kir.corp.google.com>
	<50DCD4CB.50205@oracle.com>
	<CAAmzW4MhCyYkdpOaHnJtoMoJeFsXQJXN=Cpo3s67=s+id-hrMg@mail.gmail.com>
Date: Fri, 28 Dec 2012 11:16:35 -0800
X-Google-Sender-Auth: aoqLWWsjodTd7hkyF5v3nVTB8gQ
Message-ID: <CAE9FiQVXsv1c1KAs7F6yeE_BS8Zg_s6qk8Hb0qgPFNCmEfz5gA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even if
 slab is available
From: Yinghai Lu <yinghai@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2012 at 6:42 AM, JoonSoo Kim <js1304@gmail.com> wrote:
>
> I have a different idea.
> How about removing fallback allocation in bootmem.c completely?
> I don't know why it is there exactly.
> But, warning for 'slab_is_available()' is there for a long time.
> So, most people who misuse fallback allocation change their code adequately.
> I think that removing fallback at this time is valid. Isn't it?

if you guys really want to make thing simple, please do try to help to kill
mm/bootmem.c and use memblock instead.

at last we could the wrapper mm/nobootmem.c.

Thanks

Yinghai
