Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab0JYUiI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:38:08 -0400
Received: from smtp-out.google.com ([216.239.44.51]:1419 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab0JYUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lz2SEuVAX1T4so6w1kHNcF9RiQ84O4MB/etTeYBtBJ2WStlvUwj0/F8AhbgbwnV9Q2
         wTBM/5y6i936CnvufJ8A==
Date: Mon, 25 Oct 2010 13:37:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 1/4] oom: remove totalpage normalization from
 oom_badness()
In-Reply-To: <20101025122538.9167.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1010251336080.21737@chino.kir.corp.google.com>
References: <20101025122538.9167.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010, KOSAKI Motohiro wrote:

> Current oom_score_adj is completely broken because It is strongly bound
> google usecase and ignore other all.
> 

NACK.

Same response as the previous three times this patch has been proposed:

	http://marc.info/?t=128461666500001
	http://marc.info/?t=128324705200002
	http://marc.info/?t=128272938200002
