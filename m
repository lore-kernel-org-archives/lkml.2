Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2BCHbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:31:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab2BCHbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:31:43 -0500
Date: Fri, 3 Feb 2012 08:31:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jack Steiner <steiner@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] UV Update NMI handlers
Message-ID: <20120203073131.GA30543@elte.hu>
References: <20120202235650.563029146@gulag1.americas.sgi.com>
 <20120202235651.025794606@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202235651.025794606@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> ---
>  arch/x86/kernel/apic/x2apic_uv_x.c |  132 +++++++++++++++++++++++++++++--------
>  1 file changed, 105 insertions(+), 27 deletions(-)

This patch is stock full of basic code cleanliness violations - 
it's a highly educational collection of various uglies so I'm 
going to ignore it.

Thanks,

	Ingo
