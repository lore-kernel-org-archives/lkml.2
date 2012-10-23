Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab2JWWmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:42:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61780 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab2JWWmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:42:19 -0400
Date: Tue, 23 Oct 2012 15:42:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: Julian Wollrath <jwollrath@web.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrik Kullman <patrik.kullman@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Major performance regressions in 3.7rc1/2
In-Reply-To: <CAJL_dMvUktOx9BqFm5jn2JbWbL_RWH412rdU+=rtDUvkuaPRUw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210231541350.1221@chino.kir.corp.google.com>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com> <20121022173315.7b0da762@ilfaris> <20121022214502.0fde3adc@ilfaris> <20121022170452.cc8cc629.akpm@linux-foundation.org> <alpine.LNX.2.00.1210222059120.1136@eggly.anvils>
 <20121023110434.021d100b@ilfaris> <CAJL_dMvUktOx9BqFm5jn2JbWbL_RWH412rdU+=rtDUvkuaPRUw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Anca Emanuel wrote:

> I have the same problem.
> Reverting
> https://github.com/torvalds/linux/commit/957f822a0ab95e88b146638bad6209bbc315bedd
> solves the problem for me.
> 

If you don't revert anything and do

	echo 0 > /proc/sys/vm/zone_reclaim_mode

after boot, does this also fix the issue?
