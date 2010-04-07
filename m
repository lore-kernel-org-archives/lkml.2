Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0DGJDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 05:03:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54884 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0DGJDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 05:03:42 -0400
Subject: Re: [PATCH] perf: Store active software events in a hashlist
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com>
References: <1270476502-6214-1-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 07 Apr 2010 11:02:26 +0200
Message-ID: <1270630946.5109.566.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-05 at 16:08 +0200, Frederic Weisbecker wrote:
> +#define SWEVENT_HLIST_BITS     8
> +#define SWEVENT_HLIST_SIZE     ((1 << (SWEVENT_HLIST_BITS + 1)) - 1)

That seems to result in 9 bits worth, doesn't it?


