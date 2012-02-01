Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2BABYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:24:15 -0500
Received: from seven.medozas.de ([188.40.89.202]:59360 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab2BABYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:24:13 -0500
Date: Wed, 1 Feb 2012 02:24:11 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
cc: Netfilter Developer Mailing List 
	<netfilter-devel@vger.kernel.org>,
        Linux Networking Developer Mailing List 
	<netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        eric.dumazet@gmail.com, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/6] Netfilter: Merge ipt_LOG and ip6_LOG into xt_LOG
In-Reply-To: <CAFLxGvzLvdyyaBvh7LCM2+tTmKobK6n8jTRoH8NXd=MVmN4ocA@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1201310208370.7433@frira.zrqbmnf.qr>
References: <1327269381-20748-1-git-send-email-richard@nod.at> <1327269381-20748-2-git-send-email-richard@nod.at> <CAFLxGvzLvdyyaBvh7LCM2+tTmKobK6n8jTRoH8NXd=MVmN4ocA@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 2012-01-30 10:01, richard -rw- weinberger wrote:

>On Sun, Jan 22, 2012 at 10:56 PM, Richard Weinberger <richard@nod.at> wrote:
>> ipt_LOG and ip6_LOG have a lot of common code, merge them
>> to reduce duplicate code.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>
>No comments?

Adding Pablo to Cc.


Do you have the patchset as a retrievable git tree, btw?


>[PATCH 6/6] iptables: xt_LOG: Add ring buffer support
>
>in libxt_LOG.c:
>+.size = XT_ALIGN(sizeof(struct xt_log_info_v1) + sizeof(void *)),

Why the extra void*?
