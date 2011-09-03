Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1ICGXw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 02:23:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44959 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754143Ab1ICGXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 02:23:50 -0400
Message-ID: <4E61C7F2.3090902@gmail.com>
Date: Sat, 03 Sep 2011 08:23:46 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>, Valdis.Kletnieks@vt.edu,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [next] unix stream crashes
References: <4E5FEF28.60406@gmail.com> <3179.1314924559@turing-police.cc.vt.edu> <1314927645.2576.2939.camel@schen9-DESK> <6805.1314979936@turing-police.cc.vt.edu> <1315007703.2576.2965.camel@schen9-DESK> <6043.1315028115@turing-police.cc.vt.edu> <CA+icZUVuJWpLquLk4kHJzmMKtPw24oxud=u3Na0U0HhSYqwV1w@mail.gmail.com>
In-Reply-To: <CA+icZUVuJWpLquLk4kHJzmMKtPw24oxud=u3Na0U0HhSYqwV1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2011 07:54 AM, Sedat Dilek wrote:
> I saw similiar call-traces with put_cred_rcu() - besides with
> kmem_cache_alloc_trace().
> My post-it says:
> Kernel panic - not syncing: CRED: put_cred_rcu sees f67ac0c0 with usage -43

Hm, Tim, it looks like you put a pid which you did not get?

regards,
-- 
js
