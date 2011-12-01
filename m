Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389Ab1LANSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 08:18:12 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64980 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010Ab1LANSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 08:18:10 -0500
MIME-Version: 1.0
X-Originating-IP: [41.212.118.124]
In-Reply-To: <20111130181011.GA4111@infradead.org>
References: <1319048598-15030-1-git-send-email-dsahern@gmail.com>
 <20111019183848.GE2229@ghostprotocols.net> <4E9F1AA0.4010706@gmail.com>
 <20111019192011.GG2229@ghostprotocols.net> <4E9F4B50.1060207@gmail.com>
 <20111020130041.GB1772@ghostprotocols.net> <CAHVUoiSwem2r9J==gmHPfst3_0ZB5bd0ykf9cPUMdhZFaXC9EA@mail.gmail.com>
 <CAHVUoiTeCuFLCkyEzCMJ6g1wAp+FWDR3qkSrqE3vJAYwLsRC9Q@mail.gmail.com> <20111130181011.GA4111@infradead.org>
From: Brian Marete <marete@toshnix.com>
Date: Thu, 1 Dec 2011 16:17:49 +0300
Message-ID: <CAHVUoiQC5RjuHUsfPVTQ_C+W0Khp=hQC+_csP0+fJgUnoaALAA@mail.gmail.com>
Subject: Re: [PATCH] perf top: fix crash on annotate request
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 9:10 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> https://github.com/acmel/linux/tree/perf/core
>
> It just fell thru the cracks, sorry, I should have tried to reproduce
> and fix this on the tree you reported.
>
> But if you can try with the above tree...
>
> Persistence is key, thanks for using it :)
>

Hello Arnaldo, Thanks for your reply. The perf/core branch of the tree
you suggest above gives me the same crash (with what looks to me as
the same b/trace). Would you like the details of the b/trace? The
master branch of the said tree appears too old to me (so of course it
does not suffer the crash). Which other branch of the tree should I
try?

Thanks!

-- 
Brian Gitonga Marete
Toshnix Systems
Tel: +254722151590
