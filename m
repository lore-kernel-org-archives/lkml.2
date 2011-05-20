Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935482Ab1ETJY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 05:24:58 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:60810 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935441Ab1ETJY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 05:24:56 -0400
Date: Fri, 20 May 2011 11:24:52 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the s390 tree
Message-ID: <20110520112452.13cd62a3@mschwide>
In-Reply-To: <20110520115651.fc0fc63f.sfr@canb.auug.org.au>
References: <20110520115651.fc0fc63f.sfr@canb.auug.org.au>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 11:56:51 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the s390 tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> mm/rmap.c:788:54: error: macro "page_test_and_clear_dirty" passed 2 arguments, but takes just 1
> mm/rmap.c: In function 'page_mkclean':
> mm/rmap.c:788: error: 'page_test_and_clear_dirty' undeclared (first use in this function)
> mm/rmap.c:788: error: (Each undeclared identifier is reported only once
> mm/rmap.c:788: error: for each function it appears in.)
> mm/rmap.c:983:52: error: macro "page_test_and_clear_dirty" passed 2 arguments, but takes just 1
> mm/rmap.c: In function 'page_remove_rmap':
> mm/rmap.c:983: error: 'page_test_and_clear_dirty' undeclared (first use in this function)
> 
> Caused by commit 4cbfc8b9f58c ("[S390] merge page_test_dirty and page_clear_dirty").
> 
> I have used the s390 tree from next-20110519 for today.

Oops, sorry about that. Fixed the patch and updated git390.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

