Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756Ab2AJFGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 00:06:41 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47909 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2AJFGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 00:06:39 -0500
MIME-Version: 1.0
In-Reply-To: <20120110120118.994b0bc4.kamezawa.hiroyu@jp.fujitsu.com>
References: <CAJd=RBBifQggNFtBsq0-Q_fG6mOJ-rJ544Me9pLFXbMi3Xn0gQ@mail.gmail.com>
 <20120110120118.994b0bc4.kamezawa.hiroyu@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 10 Jan 2012 00:06:18 -0500
Message-ID: <CAHGf_=rjpGWz=tcO0tcGYw9zETUoABbtYW5TXAV1XUx0t7dB8w@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: cleanup with s/reclaim_mode/isolate_mode/
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/9 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> On Fri, 6 Jan 2012 22:01:03 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
>
>> With tons of reclaim_mode(defined as one field of struct scan_control) already
>> in the file, it is clearer to rename it when setting up the isolation mode.
>>
>>
>> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>
> I like this.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I'm ok too.
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
