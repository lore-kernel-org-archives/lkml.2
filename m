Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0DNACI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 20:02:08 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:52657 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab0DNACG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 20:02:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ruzvDjWHYaIJ7yMu6FSOcjejfRuNc/swWjMHf5M1xAAHK0Yh2S0WOaB31bCGJr24+x
         XY3DuXQip5bR8YRSJ6FcH2FaSxoMLq/g52ODeK0AtP09/kdgRjc5gFsbb9LDmyGWF1EX
         lTqARJB+Wr6cfqkU63sk5jrn39X9VeVTx7cMQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1004131654340.8116@chino.kir.corp.google.com>
References: <9918f566ab0259356cded31fd1dd80da6cae0c2b.1271171877.git.minchan.kim@gmail.com>
	 <8b348d9cc1ea4960488b193b7e8378876918c0d4.1271171877.git.minchan.kim@gmail.com>
	 <alpine.DEB.2.00.1004131437140.8617@chino.kir.corp.google.com>
	 <u2o28c262361004131640zd034a692s4b46ee77c08e1ccd@mail.gmail.com>
	 <alpine.DEB.2.00.1004131654340.8116@chino.kir.corp.google.com>
Date: Wed, 14 Apr 2010 09:02:04 +0900
Message-ID: <l2p28c262361004131702m49921d78qde6b51bd5b34247c@mail.gmail.com>
Subject: Re: [PATCH 3/6] change alloc function in alloc_slab_page
From: Minchan Kim <minchan.kim@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 8:55 AM, David Rientjes <rientjes@google.com> wrote:
> On Wed, 14 Apr 2010, Minchan Kim wrote:
>
>> This changlog is bad.
>> I will change it with following as when I send v2.
>>
>> "alloc_slab_page always checks nid == -1, so alloc_page_node can't be
>> called with -1.
>>  It means node's validity check in alloc_pages_node is unnecessary.
>>  So we can use alloc_pages_exact_node instead of alloc_pages_node.
>>  It could avoid comparison and branch as 6484eb3e2a81807722 tried."
>>
>
> Each patch in this series seems to be independent and can be applied
> seperately, so it's probably not necessary to make them incremental.

Surely.
Without considering, I used git-formant-patch -n --thread.
I will keep it in mind.

Thanks, David.


-- 
Kind regards,
Minchan Kim
