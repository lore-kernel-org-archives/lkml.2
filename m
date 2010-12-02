Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0LBJnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 04:43:07 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48297 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0LBJnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 04:43:05 -0500
To: Michael Leun <lkml20101129@newton.leun.net>
CC: miklos@szeredi.hu, hughd@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20101202091552.4a63f717@xenia.leun.net> (message from Michael
	Leun on Thu, 2 Dec 2010 09:15:52 +0100)
Subject: Re: kernel BUG at mm/truncate.c:475!
References: <20101130194945.58962c44@xenia.leun.net>
	<alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com>
	<E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu>
	<20101201124528.6809c539@xenia.leun.net>
	<E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>
	<20101202084159.6bff7355@xenia.leun.net> <20101202091552.4a63f717@xenia.leun.net>
Message-Id: <E1PO5gh-00079U-Ma@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 02 Dec 2010 10:42:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Michael Leun wrote:
> > Kernel compile 2.6.36.1 with that .page_mkwrite commented out running
> > now, will reboot really soon now (TM).
> 
> OK - that happened very fast again in 2.6.36.1.
> 
> Sorry for that tainted kernel, but cannot afford to additionally have
> graphics lockups all the time - I've shown that it happens with
> untainted kernel also (long run without fault yesterday also was with
> nvidia.ko driver).
> 
> Until I've another suggestion what to try I'll swich back to 2.6.36 to
> see if it really happens less frequent there.

Can you please describe in detail the workload that's causing this to
happen?

Thanks,
Miklos
