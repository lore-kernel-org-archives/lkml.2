Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0LARWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 12:22:55 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49580 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab0LARWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 12:22:54 -0500
To: Michael Leun <lkml20101129@newton.leun.net>
CC: miklos@szeredi.hu, hughd@google.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <20101201124528.6809c539@xenia.leun.net> (message from Michael
	Leun on Wed, 1 Dec 2010 12:45:28 +0100)
Subject: Re: kernel BUG at mm/truncate.c:475!
References: <20101130194945.58962c44@xenia.leun.net>
	<alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com>
	<E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu> <20101201124528.6809c539@xenia.leun.net>
Message-Id: <E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 01 Dec 2010 18:22:33 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Dec 2010, Michael Leun wrote:
> At the moment I've downgraded to 2.6.36 - I cannot remember to have
> seen this there - which does not need to mean anything, because
> workload has changed (several unshared mount/network namespaces chrooted
> into unionfs-fuse mounted roots - cool stuff...).
> 
> Would you suspect to make 2.6.36 <> 2.6.36.1 a difference here?

No, that's unlikely.

> Later, when I've results from the test with 2.6.36 of course I'll try
> the quick test you suggested.

Okay, thanks.

Miklos
