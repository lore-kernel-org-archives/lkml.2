Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab2APH6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:58:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60417 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab2APH6l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:58:41 -0500
Date: Mon, 16 Jan 2012 08:58:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: xiyou.wangcong@gmail.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        ianfang.cn@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [Patch] x86, mm: fix the size calculation of mapping tables
Message-ID: <20120116075822.GI15641@elte.hu>
References: <1326628602-27442-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326628602-27442-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* xiyou.wangcong@gmail.com <xiyou.wangcong@gmail.com> wrote:

> For machine enables PSE, the first 2/4M memory region still uses
> 4K pages, so needs more PTEs in this case, but find_early_table_space()
> doesn't count this. This patch fixes it.
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: ianfang.cn@gmail.com
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

What were the symptoms of this bug - or have you found it via 
review only?

Thanks,

	Ingo
