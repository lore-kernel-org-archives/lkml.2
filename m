Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0DGLxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:53:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:1514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757183Ab0DGLxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:53:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JUuvLEpRFpQuc70iPUzqcVoxRH0NTpLeXcr88WTr0CEKXZOE2ux8eMoxqOjxEmNfK7
         ZqDjI9l7VsrwNBZuCFBXRgkouF8fo3N15TCJOhnna+rbhLU/uwvUMc50CAMvruK+X5Wv
         erfcF2kcIOVdazRKj131Ym2wblqZzx5mXN6NA=
Date: Wed, 7 Apr 2010 13:52:53 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Store active software events in a hashlist
Message-ID: <20100407115251.GC5143@nowhere>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com> <1270630946.5109.566.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270630946.5109.566.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 11:02:26AM +0200, Peter Zijlstra wrote:
> On Mon, 2010-04-05 at 16:08 +0200, Frederic Weisbecker wrote:
> > +#define SWEVENT_HLIST_BITS     8
> > +#define SWEVENT_HLIST_SIZE     ((1 << (SWEVENT_HLIST_BITS + 1)) - 1)
> 
> That seems to result in 9 bits worth, doesn't it?


Oh right, I was confused, will zapp the + 1.

