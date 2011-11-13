Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1KMVmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 16:42:49 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48054 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab1KMVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 16:42:48 -0500
MIME-Version: 1.0
X-Originating-IP: [197.237.16.88]
In-Reply-To: <CAHVUoiSgT8DuauMCpM1G_GWeqmHsPBzudew+5xJLuDGW7d9Ryw@mail.gmail.com>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net> <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net> <4E9F4B50.1060207@gmail.com>
 <20111020130041.GB1772@ghostprotocols.net> <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
 <20111113134314.GA2699@ghostprotocols.net> <CAHVUoiSgT8DuauMCpM1G_GWeqmHsPBzudew+5xJLuDGW7d9Ryw@mail.gmail.com>
From: Brian Marete <marete@toshnix.com>
Date: Mon, 14 Nov 2011 00:42:27 +0300
Message-ID: <CAHVUoiTSS0U4JTwukOkQ_4rhjvWEZvy6qceLqSJ1s6a=gekKKQ@mail.gmail.com>
Subject: Re: [PATCH] perf top: fix crash on annotate request
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 12:03 AM, Brian Marete <marete@toshnix.com> wrote:
> On Sun, Nov 13, 2011 at 4:43 PM, Arnaldo Carvalho de Melo
>> It is going well before the start of this symbol:
>>
>> addr(256544) < sym->start(1124896)
>>
>
> I will reproduce (which I am always able to do) run another bt and report back.
>

Sorry, had misread your comment above as a request for information.

And yes, I can reproduce this on the HEAD you have printed above with git-log.

Let me know if you need further information.

-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
