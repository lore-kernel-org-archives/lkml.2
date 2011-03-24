Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab1CXRnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:43:32 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:34623 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932656Ab1CXRn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:43:29 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: KlYFc3MVM1kxhhyKJIDUsaRPmo_C2p374xC1SZscGFdGgCD
 dRpjJ5cVbDn63hBq_zl3hkcw4T4pqNeusvZkHUNK0j6ESVcxu2zNKEJ_1FRX
 taUVTVoEpqhZnQ8YTX8JXzgII0NtGiXBrvbV3LCZ..uXnZdodB5qV781gN1W
 hAtihx2.IkPx.CltKaPZKTTmpmjseMIyNhbGbHb6WdrjhrfjcLmqjmI_FUo_
 0pIj4dkVJzBLdohErLQr1fyLrlBDi09uH5_ezNXNoY95V9Kd9_U6S_p8wEX5
 s7WlwrmG05OAJbZssENm9WLGzWnXe4RFkJRqws.eCufBKpMh_6_RV5WMX6LT
 9g6Gh1zPg8k2HbIIievBrczkm
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 24 Mar 2011 12:43:25 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: Pekka Enberg <penberg@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <20110324172653.GA28507@elte.hu>
Message-ID: <alpine.DEB.2.00.1103241242450.32226@router.home>
References: <alpine.DEB.2.00.1103221635400.4521@tiger> <20110324142146.GA11682@elte.hu> <alpine.DEB.2.00.1103240940570.32226@router.home> <AANLkTikb8rtSX5hQG6MQF4quymFUuh5Tw97TcpB0YfwS@mail.gmail.com> <20110324172653.GA28507@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Mar 2011, Ingo Molnar wrote:

> > How does alternative_io() work? Does it require
> > alternative_instructions() to be executed. If so, the fallback code
> > won't be active when we enter kmem_cache_init(). Is there any reason
> > check_bugs() is called so late during boot? Can we do something like
> > the totally untested attached patch?
>
> Does the config i sent you boot on your box? I think the bug is pretty generic
> and should trigger on any box.

The bug should only trigger on old AMD64 boxes that do not support
cmpxchg16b.


