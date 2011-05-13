Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758950Ab1EMUdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:33:20 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39447 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1EMUdT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:33:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=XF68kC/RClFUAj5T+aR9Olma6IxDSajjhNuHZO4UcsgOfiTC2d5U9Z14cTwF179akl
         dbda9IEIiJwhBn2LCHGev8UGxxPAjr1y/pu9q5zIohN9EaDWIyFd0rVdlvZgNqxoQ2lu
         mGaVd5LI2nt7AAWiAEak55gSaYWZ/PeMdVOgw=
MIME-Version: 1.0
In-Reply-To: <20110513154410.GA6373@elte.hu>
References: <BANLkTimTOTz4qNwYPa6Ey7=QRjOhQHWt-Q@mail.gmail.com>
 <4DCD4FC5.8020608@gmail.com> <20110513154410.GA6373@elte.hu>
From: Wim Heirman <wim@heirman.net>
Date: Fri, 13 May 2011 22:32:58 +0200
X-Google-Sender-Auth: iV8BXgFALgTUoGd2tgx8Pa54xvE
Message-ID: <BANLkTi=UKJ2Ztkcui_+8UHF16b_8mTvpnA@mail.gmail.com>
Subject: Re: perf-stat per thread results
To: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Brice Goglin <Brice.Goglin@inria.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> It's supposed to do that if --stat is specified, and it used to work - see this
> commit:
>
>  8d51327090ac: perf report: Fix and improve the displaying of per-thread event counters
>
> and the output there:
>
>     #  PID   TID  cache-misses  cache-references
>       4658  4659        495581           3238779
>       4658  4662        498246           3236823
>       4658  4663        499531           3243162
>
> which appears to be roughly what Wim is asking for, AFAICT.

Thanks, this is exactly what I'm looking for. In 2.6.32 (Ubuntu 10.04)
it works, although if I use --pid rather than the -- <command> variant
the first thread seams to be missing. In 2.6.38 (Ubuntu 11.04) the
first thread is missing in both use cases, and I get one column per
processor (which in itself is fine).

Regards,
Wim
