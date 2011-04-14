Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1DNAUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 20:20:45 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36537 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1DNAUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 20:20:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/4] forkbomb killer
Cc: kosaki.motohiro@jp.fujitsu.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <BANLkTi=pMapbVoUO6+7nUEg1bY4fb844-A@mail.gmail.com>
References: <20110329101234.54d5d45a.kamezawa.hiroyu@jp.fujitsu.com> <BANLkTi=pMapbVoUO6+7nUEg1bY4fb844-A@mail.gmail.com>
Message-Id: <20110414092033.0809.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 14 Apr 2011 09:20:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Minchan, Kamezawa-san,

> >> So whenever user push sysrq, older tasks would be killed and at last,
> >> root forkbomb task would be killed.
> >>
> >
> > Maybe good for a single user system and it can send Sysrq.
> > But I myself not very excited with this new feature becasuse I need to
> > run to push Sysrq ....
> >
> > Please do as you like, I think the idea itself is interesting.
> > But I love some automatic ones. I do other jobs.
> 
> Okay. Thanks for the comment, Kame.
> 
> I hope Andrew or someone gives feedback forkbomb problem itself before
> diving into this.

May I ask current status of this thread? I'm unhappy if our kernel keep 
to have forkbomb weakness. ;)
Can we consider to take either or both idea?



